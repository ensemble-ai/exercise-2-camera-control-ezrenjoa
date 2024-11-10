# Solution Assessment #

## Peer-reviewer Information

* *name:* Anunay Akhaury 
* *email:* aakhaury@ucdavis.edu

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera controller remains centered on the vessel, ensuring smooth and consistent tracking. The draw logic correctly displays a centered 5x5 unit cross only when draw_camera_logic is set to true. Camera also remains locked when the player is in super boost mode as well.

___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera controller's frame-bound autoscroller works as expected, moving the player within the z-x plane box. The player is smoothly pushed forward by the left edge of the box if they fall behind, which is the intended behavior. Additionally, the frame border box is displayed accurately when draw_camera_logic is set to true. The exported fields top_left and bottom_right work, allowing easy customization of the frame size. Adjusting these values directly impacts the dimensions of the frame, and modifying autoscroll_speed correctly changes the scrolling speed and direction on the x and z axes.

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera behaves as intended, following the player and catching up when the player breaks the leash distance or stops movement. The camera smoothly approaches the player at the speed of follow speed and leaves enough distance to allow for following. Catchup speed works as well allowing the camera to catch up smoothly once the player stops. Changing the follow_speed, catchup_speed, and leash_distance all work as well within the editor. One minor issue was when the player starts to super boost the distance between the player and the camera is sometimes inconsistent, sometimes being the leash distance or sometimes being shorter than that. But the camera follows the player even during a super boost. The draw logic correctly displays a 5x5 unit cross only when draw_camera_logic is set to true

___
### Stage 4 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The camera behaves as intended, and it leads the player in whatever direction they are moving in. The camera only moves a maximum of the leash distance away from the player and the camera returns back to the target using the catchup speed. The catchup delay also works as intended, only catching the player up once the delay has passed. The draw logic correctly displays a 5x5 unit cross only when draw_camera_logic is set to true. The floats lead_speed, catchup_delay_duration, catchup_speed, and leash_distance are all properly modifiable using the interface in the editor. The camera doesn't follow the player as intended when super boost is active though, causing for unpredictable behavior where the player will get ahead of the camera or won't be at a leash distance away.
___
### Stage 5 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
The 4-way speedup zone works as intended. The camera does not move when the player is inside the inner most area. When the player leaves the inner area the player moves as a speed times the push ratio that is set. Once the player hits the outside borders on any side, the player starts to move at their actual speed. The push_ratio, pushbox_top_left, pushbox_bottom_right, speedup_zone_top_left, speedup_zone_bottom_right all are exported correctly and easily modifiable from the editor. But when one thing is that when the draw logic is true only the outer boder is drawn, it would have been nice to visualise the inner speed up zone.
___
# Code Style #


### Description ###

The user has used ver good code style with no imperfections. The user has formated their code with the proper indentations and spacing. Spacing around operators and assignments are done correctly. The name conventions for both variable names and class names follow their respective case type. Type hints are placed upon the varibales and methods ensuring correct infered typing. The comments that are written are brier but provide valuable information about the code. Overall the use practices good code style according to the godot style guide and has made no clear infractions to it.

#### Style Guide Infractions ####

#### Style Guide Exemplars ####

[Consistent use of type hints](https://github.com/ensemble-ai/exercise-2-camera-control-ezrenjoa/blob/99726fa635354a197638d1af666c8bd89f005ff5/Obscura/scripts/camera_controllers/speedup_push_box.gd#L5) -  the user makes sure to give all variable type hints which allows for the code to be cleaner and ensures that there will be no type-related errors.

[Consistent Double Spacing in Between Functions](https://github.com/ensemble-ai/exercise-2-camera-control-ezrenjoa/blob/99726fa635354a197638d1af666c8bd89f005ff5/Obscura/scripts/camera_controllers/position_lock.gd#L11) - Functions are seperated by two blank lines just as how the style guide reccomends. This allows for the code to be much cleaner and much easier to read since the functions are seperated.

[Spacing Around Operators](https://github.com/ensemble-ai/exercise-2-camera-control-ezrenjoa/blob/99726fa635354a197638d1af666c8bd89f005ff5/Obscura/scripts/camera_controllers/lerp_look_ahead.gd#L45) - There is consistant spacing around all the operators which complies with the godot style guide. This spacing makes it easier to read different expressions and overall cleans up the code.
___
#### Put style guide infractures ####

No style guide infractions, the user adheres to the godot style guide very well and makes sure to write clean and readable code.
___

# Best Practices #

### Description ###

The user for the most part, follows best practices in their code. One slight infraction is that throughout the files, the user accesses the properties of the target. This is not the best practice since continuously assessing the variable can be less efficient. On the other hand, the suer showcases multiple best practices by writing explicit comments and introducing descriptive variable names.


#### Best Practices Infractions ####

[Repeated acsess to target.position and target.velocity](https://github.com/ensemble-ai/exercise-2-camera-control-ezrenjoa/blob/99726fa635354a197638d1af666c8bd89f005ff5/Obscura/scripts/camera_controllers/lerp_follow.gd#L26) - Both target.position and target.velocity are used multiple times in the code. Storing these in local variables at the start is best practice since not doing so would introduce a slight overhead.

#### Best Practices Exemplars ####

[Clear Comments for Boundry Checks](https://github.com/ensemble-ai/exercise-2-camera-control-ezrenjoa/blob/99726fa635354a197638d1af666c8bd89f005ff5/Obscura/scripts/camera_controllers/speedup_push_box.gd#L40) - The addition of specific comments regarding the boundry changes helps clarify the purpose of each of the blocks and especially in complex conditions its make it clear what part of the code is exactly effecting which part

[Descriptive Variable Names](https://github.com/ensemble-ai/exercise-2-camera-control-ezrenjoa/blob/35a9b519f33beedb8e46bc0db9dc36187e489419/Obscura/scripts/camera_controllers/lerp_follow.gd#L36) - The use uses descriptive variable names clearly defining what each variable represents. This reduces the change of leaving anything up for interpretation and allows for people who are new to the code base to easily understand what each variable is meant for. Also reduces the need for extra comments and makes the code just more readable.