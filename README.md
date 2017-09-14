
## Assumption
Assume that the controller is operating at the night.

## Requirements and description
* A Hotel can have multiple floors
* Each floor can have multiple main corridors and sub corridors
* Both main corridor and sub corridor have one light each
* Both main and sub corridor lights consume 5 units of power when ON
* Both main and sub corridor have independently controllable AC's
* Both main and sub corridor AC's consume 10 units of power when ON
* All the lights in all the main corridors need to be switched ON between 6PM to 6AM,
which is the Night time slot
* When a motion is detected in one of the sub corridors the corresponding lights need to
be switched ON between 6PM to 6AM (Night time slot)
* When there is no motion for more than a minute the sub corridor lights should be
switched OFF
* The total power consumption of all the AC's and lights combined should not exceed
(Number of Main corridors * 15) + (Number of sub corridors * 10) units of per floor. Sub corridor AC could be switched OFF to ensure that the power consumption is not more than the specified maximum value
* When the power consumption goes below the specified maximum value the AC's that were switched OFF previously must be switched ON

## Needs
Write a program that takes input values for Floors, Main corridors, Sub corridors and takes different external inputs for motion in sub corridors and for each input prints out the state of all the lights and AC's in the hotel.  

Motion in sub corridors is input to the controller. Controller need to keep track and optimize the power consumption.


## Inputs/Outputs

### Input: Initial
```
Number of floors: 2
Main corridors per floor: 1
Sub corridors per floor: 2
```

### Output: Default
```
Floor 1
  Main corridor 1
    Light 1 : ON
    AC : ON
    Sub corridor 1
      Light 1 : OFF
      AC :  ON
    Sub corridor 2
      Light 2 :  OFF
      AC : ON
Floor 2
  Main corridor 1
    Light 1 : ON
    AC : ON
      Sub corridor 1
        Light 1 : OFF
        AC : ON
      Sub corridor 2
        Light 2 : OFF
        AC : ON
```
### Input: Movement in Floor 1, Sub corridor 2

### Output
```
Floor 1
  Main corridor 1
    Light 1 : ON
    AC : ON
    Sub corridor 1
      Light 1 : OFF
      AC :  OFF
    Sub corridor 2
      Light 2 :  ON
      AC : ON
Floor 2
  Main corridor 1
    Light 1 : ON
    AC : ON
      Sub corridor 1
        Light 1 : OFF
        AC : ON
      Sub corridor 2
        Light 2 : OFF
        AC : ON
```
### Input: No movement in Floor 1, Sub corridor 2 for a minute

### Output
```
Floor 1
  Main corridor 1
    Light 1 : ON
    AC : ON
    Sub corridor 1
      Light 1 : OFF
      AC :  ON
    Sub corridor 2
      Light 2 :  OFF
      AC : ON
Floor 2
  Main corridor 1
    Light 1 : ON
    AC : ON
      Sub corridor 1
        Light 1 : OFF
        AC : ON
      Sub corridor 2
        Light 2 : OFF
        AC : ON
```
