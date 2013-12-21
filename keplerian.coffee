# Based on NASA JPL - http://ssd.jpl.nasa.gov/txt/aprx_pos_planets.pdf
# Perhaps increase accuracy with big.js

keplerian_position = (data, centuries) ->
  data = data.kepler
  T = centuries # past J2000.0
  
  # http://ssd.jpl.nasa.gov/txt/p_elem_t1.txt
  keplerian_value = (data, value, T) ->
    data[value + '0'] + data[value + '1'] * T
  
  a = keplerian_value(data, 'a', T)
  e = keplerian_value(data, 'e', T)
  I = keplerian_value(data, 'I', T)
  L = keplerian_value(data, 'L', T)
  p = keplerian_value(data, 'p', T)
  n = keplerian_value(data, 'n', T)
  
  # Argument of perihelion
  w = p - n
  
  # Mean anomaly
  M = L - p
  
  to_degrees = (angle) -> angle * (180 / Math.PI)
  to_radians = (angle) -> angle * (Math.PI / 180)
  
  approximate_E = (e, M) ->
    e_star = to_degrees(e)
    tolerance = Math.pow 10, -4
    E_n =  M + e_star * Math.sin(to_radians M)
    delta_E = 1
    i = 0
    while Math.abs(delta_E) > tolerance
      delta_M = M - (E_n - e_star * Math.sin(to_radians E_n))
      delta_E = delta_M / (1 - e * Math.cos(to_radians E_n))
      E_n = E_n + delta_E
      i++
      if i > 3000
        console.error 'Maximum iterations reached while approximating E_n with ' + e + ' and ' + M
        break
    return to_radians E_n
  
  E = approximate_E(e, M)
  
  x_ = a * (Math.cos(E) - e)
  y_ = a * Math.sqrt(1 - Math.pow(e, 2)) * Math.sin(E)
  z_ = 0
  
  # Prepare frequently calculated values
  w_rad = to_radians w
  n_rad = to_radians n
  I_rad = to_radians I
  L_rad = to_radians L
  
  cos_w_rad = Math.cos(w_rad)
  sin_w_rad = Math.sin(w_rad)
  cos_n_rad = Math.cos(n_rad)
  sin_n_rad = Math.sin(n_rad)
  cos_I_rad = Math.cos(I_rad)
  sin_I_rad = Math.sin(I_rad)
  
  x = (cos_w_rad * cos_n_rad - sin_w_rad * sin_n_rad * cos_I_rad) * x_ + (-sin_w_rad * cos_n_rad - cos_w_rad * sin_n_rad * cos_I_rad) * y_
  y = (cos_w_rad * sin_n_rad + sin_w_rad * cos_n_rad * cos_I_rad) * x_ + (-sin_w_rad * sin_n_rad + cos_w_rad * cos_n_rad * cos_I_rad) * y_
  z = (sin_w_rad * sin_I_rad) * x_ + (cos_w_rad * sin_I_rad) * y_
  
  # Obtain equatorial coordinates in ICRF / J2000 frame
  # obliquity = to_radians 23.43828
  # x_eq = x
  # y_eq = Math.cos(obliquity) * y - Math.sin(obliquity) * z
  # z_eq = Math.sin(obliquity) * y - Math.cos(obliquity) * z

  return {'x': x, 'y': y, 'z': z}

# Export function
root = exports ? this
root.keplerian_position = keplerian_position