
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
(Number of Main corridors x 15) + (Number of sub corridors x 10) units of per floor. Sub corridor AC could be switched OFF to ensure that the power consumption is not more than the specified maximum value
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

## Initial configuration
The created system takes this constants start and create model instances.

```ruby
# config/init.rb
FLOORS_CONFIG =
  [
    {
      number: 1,
      main_corridors: [{
          number: 1,
          sub_corridors: [{number:1},{number:2}]
        }]
    },
    {
      number: 2,
      main_corridors: [{
          number: 1,
          sub_corridors: [{number:1},{number:2}]
        }]
    },
  ]

APPLIANCES_CONFIG = [
      {
        type: 'ac',
        location: 'main',
        qty_per_location: 1,
        energy_consuption: 10
      },
      {
        type: 'ac',
        location: 'sub',
        qty_per_location: 1,
        energy_consuption: 10
      },
      {
        type: 'light',
        location: 'main',
        qty_per_location: 1,
        energy_consuption: 5
      },
      {
        type: 'light',
        location: 'sub',
        qty_per_location: 1,
        energy_consuption: 5
      },
    ]

RESTRICTION = {
    level: 'floor',
    main_times: 10 ,
    sub_times: 15,
    main_lights_always_on: true,
    sub_lights_always_on: false,
  }

```

## Objects in System

### Models
Appliance
Building
Sensor

### Controllers
OperationController

### View
OperationView

Appliance.all =>
```ruby
{
  "1_1_0_ac"=>
    #<Appliance:0x007f9fb4894e18
    @energy_consuption=10,
    @floor_number=1,
    @id="1_1_0_ac",
    @location="main",
    @number=1,
    @on=true,
    @type="ac">,
  "2_1_0_ac"=>
    #<Appliance:0x007f9fb48946c0
    @energy_consuption=10,
    @floor_number=2,
    @id="2_1_0_ac",
    @location="main",
    @number=1,
    @on=true,
    @type="ac">,
  "1_1_1_ac"=>
    #<Appliance:0x007f9fb488ff08
    @energy_consuption=10,
    @floor_number=1,
    @id="1_1_1_ac",
    @location="sub",
    @number=1,
    @on=true,
    @type="ac">,
  "1_1_2_ac"=>
    #<Appliance:0x007f9fb488fbe8
    @energy_consuption=10,
    @floor_number=1,
    @id="1_1_2_ac",
    @location="sub",
    @number=2,
    @on=true,
    @type="ac">,
  "2_1_1_ac"=>
    #<Appliance:0x007f9fb488f8a0
    @energy_consuption=10,
    @floor_number=2,
    @id="2_1_1_ac",
    @location="sub",
    @number=1,
    @on=true,
    @type="ac">,
  "2_1_2_ac"=>
    #<Appliance:0x007f9fb488f5d0
    @energy_consuption=10,
    @floor_number=2,
    @id="2_1_2_ac",
    @location="sub",
    @number=2,
    @on=true,
    @type="ac">,
  "1_1_0_light"=>
    #<Appliance:0x007f9fb488f0d0
    @energy_consuption=5,
    @floor_number=1,
    @id="1_1_0_light",
    @location="main",
    @number=1,
    @on=true,
    @type="light">,
  "2_1_0_light"=>
    #<Appliance:0x007f9fb488ec70
    @energy_consuption=5,
    @floor_number=2,
    @id="2_1_0_light",
    @location="main",
    @number=1,
    @on=true,
    @type="light">,
  "1_1_1_light"=>
    #<Appliance:0x007f9fb488e798
    @energy_consuption=5,
    @floor_number=1,
    @id="1_1_1_light",
    @location="sub",
    @number=1,
    @on=false,
    @type="light">,
  "1_1_2_light"=>
    #<Appliance:0x007f9fb488e478
    @energy_consuption=5,
    @floor_number=1,
    @id="1_1_2_light",
    @location="sub",
    @number=2,
    @on=false,
    @type="light">,
  "2_1_1_light"=>
    #<Appliance:0x007f9fb488e0b8
    @energy_consuption=5,
    @floor_number=2,
    @id="2_1_1_light",
    @location="sub",
    @number=1,
    @on=false,
    @type="light">,
  "2_1_2_light"=>
    #<Appliance:0x007f9fb488dcf8
    @energy_consuption=5,
    @floor_number=2,
    @id="2_1_2_light",
    @location="sub",
    @number=2,
    @on=false,
    @type="light">
 }
```
Sensor.all =>
```ruby
{"1_1_0"=>
  #<Sensor:0x007ff21a461270
   @armed=false,
   @floor_number=1,
   @id="1_1_0",
   @location="main",
   @observer_peers=
    {#<OperationsController:0x007ff21a4688b8}>,
 "1_1_1"=>
  #<Sensor:0x007ff21a461090
   @armed=false,
   @floor_number=1,
   @id="1_1_1",
   @location="sub",
   @observer_peers=
    {#<OperationsController:0x007ff21a4688b8}>,
 "1_1_2"=>
  #<Sensor:0x007ff21a460a28
   @armed=false,
   @floor_number=1,
   @id="1_1_2",
   @location="sub",
   @observer_peers=
    {#<OperationsController:0x007ff21a4688b8}>,
 "2_1_0"=>
  #<Sensor:0x007ff21a460870
   @armed=false,
   @floor_number=2,
   @id="2_1_0",
   @location="main",
   @observer_peers=
    {#<OperationsController:0x007ff21a4688b8}>,
 "2_1_1"=>
  #<Sensor:0x007ff21a4606e0
   @armed=false,
   @floor_number=2,
   @id="2_1_1",
   @location="sub",
   @observer_peers=
    {#<OperationsController:0x007ff21a4688b8}>,
 "2_1_2"=>
  #<Sensor:0x007ff21a460578
   @armed=false,
   @floor_number=2,
   @id="2_1_2",
   @location="sub",
   @observer_peers=
    {#<OperationsController:0x007ff21a4688b8}>,
```
