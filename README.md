# Planets with Coffeescript
Calculate the approximate position (relative to the sun) of major planets in our solar system with Coffeescript.

```coffeescript
mars = {
  "name": "Mars",
  "kepler":{
    "a0": 1.52371034,
    "a1": 0.00001847,
    "e0": 0.09339410,
    "e1": 0.00007882,
    "I0": 1.84969142,
    "I1": -0.00813131,
    "L0": -4.55343205,
    "L1": 19140.30268499,
    "p0": -23.94362959,
    "p1": 0.44441088,
    "n0": 49.55953891,
    "n1": -0.29257343
  }
}
centuries_past_j2000 = 0
console.log keplerian_position(mars, centuries_past_j2000)
# { x: 1.3906677476780214,
#  y: -0.013391064158330357,
#  z: -0.03446125922330577 }
```
The resulting coordinate (x, y, z) is in [AU](http://en.wikipedia.org/wiki/Astronomical_unit) (astronomical units) relative to the sun.

See data.txt for coefficients for other planets. JPL also has another file with valid coefficients for other years (beyond 2050). To find it, with also the approximate errors, [go here](http://ssd.jpl.nasa.gov/?planet_pos).

## I'm interested in the math
Luckily JPL has released this awesome [PDF document](http://ssd.jpl.nasa.gov/txt/aprx_pos_planets.pdf).