# Basic cfg structure
```json
{
  "screen": ...,
  "structure": ...,
  "objects": [ ... ],
  "lights": [ ... ]
}
```


# Basic types
| type names | meaning                                       |
| ---------- | --------------------------------------------- |
| point      | [`<float/int>`, `<float/int>`, `<float/int>`] |
| vector     | [`<float/int>`, `<float/int>`, `<float/int>`] |
| color      | [`<int>`, `<int>`, `<int>`]                   |


# Screen
| key           | value type         | description                   |
| ------------- | ------------------ | ----------------------------- |
| type          | "PerpectiveScreen" |                               |
| resolution    | [`<int>`, `<int>`] |                               |
| defaultColor  | color              | background color              |
| unitsPerPixel | `<float/int>`      | pixel width                   |
| camera        | camera             | camera object described below |

Example:
```json
{
  "type": "PerpectiveScreen",
  "camera": {
    "center": [0, 30, -150],
    "forward": [0, 0, 1],
    "up": [0, 1, 0],
    "distanceFromScreen": 100
  },
  "resolution": [800, 600],
  "defaultColor": [100, 100, 100],
  "unitsPerPixel": 0.1
}
```

## Camera
| key                | value type    | description                                                                                |
| ------------------ | ------------- | ------------------------------------------------------------------------------------------ |
| center             | point         | camera point                                                                               |
| forward            | vector        | the direction in which the camera is heading                                               |
| up                 | vector        | the direction to the top of the screen. It must be perpendicular to the **forward** vector |
| distanceFromScreen | `<float/int>` | distance between screen center and camera point                                            |

Example:
```json
{
  "center": [0, 30, -150],
  "forward": [0, 0, 1],
  "up": [0, 1, 0],
  "distanceFromScreen": 100
}
```


# Structure
| key  | value type      |
| ---- | --------------- |
| type | "ListStructure" |

Example:
```json
{
  "type": "ListStructure"
}
```


# Objects

## Plane
| key    | value type    | description                         |
| ------ | ------------- | ----------------------------------- |
| type   | "Plane"       |                                     |
| point  | point         | point on the plane                  |
| normal | vector        | vector perpendicular to the surface |
| albedo | `<float/int>` | reflect light : incident light      |
| color  | color         |                                     |

Example:
```json
{
  "type": "Plane",
  "point": [-100, 0, 0],
  "normal": [1, 0, -1],
  "albedo": 0.18,
  "color": [255, 255, 255]
}
```

## Sphere
| key    | value type    | description                    |
| ------ | ------------- | ------------------------------ |
| type   | "Sphere"      |                                |
| center | point         | center of the sphere           |
| radius | `<float/int>` |                                |
| albedo | `<float/int>` | reflect light : incident light |
| color  | color         |                                |

Example:
```json
{
  "type": "Sphere",
  "center": [40, 30, 44],
  "radius": 10,
  "albedo": 0.18,
  "color": [255, 255, 255]
}
```


# Lights

## Sun
| key       | value type | description                      |
| --------- | ---------- | -------------------------------- |
| type      | "Sun"      |                                  |
| direction | vector     | direction of incoming light rays |
| color     | color      |                                  |

Example:
```json
{
  "type": "Sun",
  "direction": [-1, -1, 0],
  "color": [255, 255, 255]
}
```

## LightPoint
| key       | value type    | description          |
| --------- | ------------- | -------------------- |
| type      | "LightPoint"  |                      |
| center    | point         | center of the sphere |
| intensity | `<float/int>` |                      |
| color     | color         |                      |

Example:
```json
{
  "type": "LightPoint",
  "center": [0, 50, 0],
  "intensity": 30000,
  "color": [255, 0, 0]
}
```
