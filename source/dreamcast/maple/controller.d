/** \file    dc/maple/controller.h
    \brief   Definitions for using the controller device.
    \ingroup controller

    This file contains the definitions needed to access the Maple controller
    device. Obviously, this corresponds to the MAPLE_FUNC_CONTROLLER function
    code.

    \author Jordan DeLong
    \author Megan Potter
    \author Falco Girgis
    \author Luna the Foxgirl

    \defgroup controller Controller
    \brief    Controller Maple Device API
    \ingroup  maple

    This module contains the public API for the controller
    maple driver.

    A standard, first-party Dreamcast controller has
    the following button configuration:

                                ___________
                               / |  __  |  \
          L trigger ------|   /  | |  | |   \  |----- R trigger
                         _|__/   | |__| |    \_|__
                        |  _      \____/          |
           Joystick ----|-/ \               (Y)   |
                        | \_/            (X)   (B)|
                        |    _              (A)   |
                        |  _| |_                  |
              D-Pad ----|-|_   _|                 |
                        |   |_|     /\            |
                         \         /__\          /
                          \    _____|_______    /
                           \  /     |       \  /
                            \/      |        \/
                               Start button

   You can grab a pointer to a connected controller by 
   using the following:

        maple_device_t *device = maple_enum_type(N, MAPLE_FUNC_CONTROLLER);

        if(device) printf("Controller found!\n");
        else printf("Controller not found!\n");

    where N is the controller number. 0 would be the first 
    controller found, which may not necessarily be on port A.

    \defgroup controller_inputs Querying Inputs
    \brief    API used to query for input state
    \ingroup  controller

    The following API is used to check for a controller's input state.

    You can grab a controller's state structure, containing the state
    of all of its inputs by using:

        cont_state_t *state = (cont_state_t *)maple_dev_status(device);

    Next you can check for the state of a particular button with:

        if(state->a)                // Check via bitfield
            printf("Pressed A".);

    or

        if(state->buttons & CONT_A) // Check via applying bitmask
            printf("Pressed A.")

    \defgroup controller_input_masks Inputs
    \brief    Collection of all status masks for checking input
    \ingroup  controller_inputs
  
    A set of bitmasks representing each input source on a controller, used to
    check its status.

    @{
*/
module dreamcast.maple.controller;
import dreamcast.maple;

extern(C):
nothrow:
@nogc:

enum CONT_C              = (1<<0);      /**< \brief C button Mask. */
enum CONT_B              = (1<<1);      /**< \brief B button Mask. */
enum CONT_A              = (1<<2);      /**< \brief A button Mask. */
enum CONT_START          = (1<<3);      /**< \brief Start button Mask. */
enum CONT_DPAD_UP        = (1<<4);      /**< \brief Main Dpad Up button Mask. */
enum CONT_DPAD_DOWN      = (1<<5);      /**< \brief Main Dpad Down button Mask. */
enum CONT_DPAD_LEFT      = (1<<6);      /**< \brief Main Dpad Left button Mask. */
enum CONT_DPAD_RIGHT     = (1<<7);      /**< \brief Main Dpad right button Mask. */
enum CONT_Z              = (1<<8);      /**< \brief Z button Mask. */
enum CONT_Y              = (1<<9);      /**< \brief Y button Mask. */
enum CONT_X              = (1<<10);     /**< \brief X button Mask. */
enum CONT_D              = (1<<11);     /**< \brief D button Mask. */
enum CONT_DPAD2_UP       = (1<<12);     /**< \brief Secondary Dpad Up button Mask. */
enum CONT_DPAD2_DOWN     = (1<<13);     /**< \brief Secondary Dpad Down button Mask. */
enum CONT_DPAD2_LEFT     = (1<<14);     /**< \brief Secondary Dpad Left button Mask. */
enum CONT_DPAD2_RIGHT    = (1<<15);     /**< \brief Secondary Dpad Right button Mask. */



/** \brief   Controller buttons for standard reset action
    \ingroup controller_inputs
    
    Convenience macro providing the standard button combination
    used as a reset mechanism by most retail games.
*/
enum CONT_RESET_BUTTONS  = (CONT_A | CONT_B | CONT_X | CONT_Y | CONT_START);

/** \brief   Controller state structure.
    \ingroup controller_inputs

    This structure contains information about the status of the controller
    device and can be fetched by casting the result of maple_dev_status() to
    this structure.

    A 1 bit in the buttons' bitfield indicates that a button is pressed, and the
    joyx, joyy, joy2x, joy2 values are all 0 based (0 is centered).

    \note
    Whether a particular field or button is actually used by the controller
    depends upon its capabilities. See \ref controller_query_caps.

    \sa maple_dev_status
*/
struct cont_state_t {
extern(C):
nothrow:
@nogc:
    uint buttons;
    int ltrig;    /**< \brief Left trigger value (0-255). */
    int rtrig;    /**< \brief Right trigger value (0-255). */
    int joyx;     /**< \brief Main joystick x-axis value (-128 - 127). */
    int joyy;     /**< \brief Main joystick y-axis value. */
    int joy2x;    /**< \brief Secondary joystick x-axis value. */
    int joy2y;    /**< \brief Secondary joystick y-axis value. */

    pragma(inline, true) bool c() { return (buttons | CONT_C) != 0; }
    pragma(inline, true) bool b() { return (buttons | CONT_B) != 0; }
    pragma(inline, true) bool a() { return (buttons | CONT_A) != 0; }
    pragma(inline, true) bool start() { return (buttons | CONT_START) != 0; }
    pragma(inline, true) bool dpad_up() { return (buttons | CONT_DPAD_UP) != 0; }
    pragma(inline, true) bool dpad_down() { return (buttons | CONT_DPAD_DOWN) != 0; }
    pragma(inline, true) bool dpad_left() { return (buttons | CONT_DPAD_LEFT) != 0; }
    pragma(inline, true) bool dpad_right() { return (buttons | CONT_DPAD_RIGHT) != 0; }
    pragma(inline, true) bool z() { return (buttons | CONT_Z) != 0; }
    pragma(inline, true) bool y() { return (buttons | CONT_Y) != 0; }
    pragma(inline, true) bool x() { return (buttons | CONT_X) != 0; }
    pragma(inline, true) bool d() { return (buttons | CONT_D) != 0; }
    pragma(inline, true) bool dpad2_up() { return (buttons | CONT_DPAD2_UP) != 0; }
    pragma(inline, true) bool dpad2_down() { return (buttons | CONT_DPAD2_DOWN) != 0; }
    pragma(inline, true) bool dpad2_left() { return (buttons | CONT_DPAD2_LEFT) != 0; }
    pragma(inline, true) bool dpad2_right() { return (buttons | CONT_DPAD2_RIGHT) != 0; }
}

/** \brief   Controller automatic callback type.
    \ingroup controller_inputs

    Functions of this type can be set with cont_btn_callback() to respond
    automatically to the specified set of buttons being pressed. This can be
    used, for instance, to implement the standard A+B+X+Y+Start method of ending
    the program running.

    \warning
    Your callback will be invoked within a context with interrupts disabled.
    See cont_btn_callback for more information.

    \param addr             Maple BUS address to poll for the button mask
                            on, or 0 for all ports.
    \param btns             Mask of all buttons which should be pressed to
                            trigger the callback.

    \sa cont_btn_callback
*/
alias cont_btn_callback_t = void function(ubyte addr, uint btns);


/** \brief   Set an automatic button press callback.
    \ingroup controller_inputs

    This function sets a callback function to be called when the specified
    controller has the set of buttons given pressed.

    \note 
    The callback gets invoked for the given maple port; however, providing
    an address of '0' will cause it to be invoked for any port with a 
    device pressing the given buttons. Since you are passed back the address 
    of this device, You are free to implement your own filtering logic within
    your callback.

    \warning
    The provided callback function is invoked within a context which has
    interrupts disabled. This means that you should not do any sort of complex
    processing or make any API calls which depend on interrupts to complete,
    such as Maple or etherent processing whichy rely on packet transmission,
    any sleeping or threading calls, blocking on any sort of file I/O, etc. 
    This mechanism is typically used to quickly terminate the application
    and should be used with caution.

    \param  addr            The controller to listen on (or 0 for all ports). 
                            This value can be obtained by using maple_addr().
    \param  btns            The buttons bitmask to match.
    \param  cb              The callback to call when the buttons are pressed.
*/
void cont_btn_callback(ubyte addr, uint btns, cont_btn_callback_t cb);

/** \defgroup controller_caps Capabilities
    \brief    Bit masks used to identify controller capabilities
    \ingroup  controller_query_caps

    These bits will be set in the function_data for the controller's deviceinfo
    if the controller supports the corresponding button/axis capability.

    \note
    The ordering here is so that they match the order found in 
    \ref controller_input_masks.

    @{
*/
enum CONT_CAPABILITY_C               = (1<<24);     /**< \brief C button capability mask. */
enum CONT_CAPABILITY_B               = (1<<25);     /**< \brief B button capability mask. */
enum CONT_CAPABILITY_A               = (1<<26);     /**< \brief A button capability mask. */
enum CONT_CAPABILITY_START           = (1<<27);     /**< \brief Start button capability mask. */
enum CONT_CAPABILITY_DPAD_UP         = (1<<28);     /**< \brief First Dpad up capability mask. */
enum CONT_CAPABILITY_DPAD_DOWN       = (1<<29);     /**< \brief First Dpad down capability mask. */
enum CONT_CAPABILITY_DPAD_LEFT       = (1<<30);     /**< \brief First Dpad left capability mask. */
enum CONT_CAPABILITY_DPAD_RIGHT      = (1<<31);     /**< \brief First Dpad right capability mask. */
enum CONT_CAPABILITY_Z               = (1<<16);     /**< \brief Z button capability mask. */
enum CONT_CAPABILITY_Y               = (1<<17);     /**< \brief Y button capability mask. */
enum CONT_CAPABILITY_X               = (1<<18);     /**< \brief X button capability mask. */
enum CONT_CAPABILITY_D               = (1<<19);     /**< \brief D button capability mask. */
enum CONT_CAPABILITY_DPAD2_UP        = (1<<20);     /**< \brief Second Dpad up capability mask. */
enum CONT_CAPABILITY_DPAD2_DOWN      = (1<<21);     /**< \brief Second Dpad down capability mask. */
enum CONT_CAPABILITY_DPAD2_LEFT      = (1<<22);     /**< \brief Second Dpad left capability mask. */
enum CONT_CAPABILITY_DPAD2_RIGHT     = (1<<23);     /**< \brief Second Dpad right capability mask. */
enum CONT_CAPABILITY_RTRIG           = (1<<8);      /**< \brief Right trigger capability mask. */
enum CONT_CAPABILITY_LTRIG           = (1<<9);      /**< \brief Left trigger capability mask. */
enum CONT_CAPABILITY_ANALOG_X        = (1<<10);     /**< \brief First analog X axis capability mask. */
enum CONT_CAPABILITY_ANALOG_Y        = (1<<11);     /**< \brief First analog Y axis capability mask. */
enum CONT_CAPABILITY_ANALOG2_X       = (1<<12);     /**< \brief Second analog X axis capability mask. */
enum CONT_CAPABILITY_ANALOG2_Y       = (1<<13);     /**< \brief Second analog Y axis capability mask. */
/** @} */

/** \defgroup controller_caps_groups Capability Groups
    \brief    Bit masks representing common groups of capabilities
    \ingroup  controller_query_caps

    These are a sets of capabilties providing a 
    convenient way to test for high-level features,
    such as dual-analog sticks or extra buttons.

    @{
*/
/** \brief Standard button (A, B, X, Y, Start) controller capabilities */
enum CONT_CAPABILITIES_STANDARD_BUTTONS    = (CONT_CAPABILITY_A |
                                              CONT_CAPABILITY_B |
                                              CONT_CAPABILITY_X |
                                              CONT_CAPABILITY_Y |
                                              CONT_CAPABILITY_START);

/** \brief Directional pad (up, down, left right) controller capabilities */
enum CONT_CAPABILITIES_DPAD                = (CONT_CAPABILITY_DPAD_UP |
                                              CONT_CAPABILITY_DPAD_DOWN |
                                              CONT_CAPABILITY_DPAD_LEFT |
                                              CONT_CAPABILITY_DPAD_RIGHT);

/** \brief Analog stick (X, Y axes) controller capabilities */
enum CONT_CAPABILITIES_ANALOG              = (CONT_CAPABILITY_ANALOG_X |
                                              CONT_CAPABILITY_ANALOG_Y);

/** \brief Trigger (L, R lever) controller capabilities */
enum CONT_CAPABILITIES_TRIGGERS            = (CONT_CAPABILITY_LTRIG |
                                              CONT_CAPABILITY_RTRIG);

/** \brief Extended button (C, Z) controller capabilities */
enum CONT_CAPABILITIES_EXTENDED_BUTTONS    = (CONT_CAPABILITY_C |
                                              CONT_CAPABILITY_Z);

/** \brief Secondary directional pad (up, down, left, right) controller capabilities */
enum CONT_CAPABILITIES_SECONDARY_DPAD      = (CONT_CAPABILITY_DPAD2_UP |
                                              CONT_CAPABILITY_DPAD2_DOWN |
                                              CONT_CAPABILITY_DPAD2_LEFT |
                                              CONT_CAPABILITY_DPAD2_RIGHT);

/** \brief Secondary analog stick (X, Y axes) controller capabilities */
enum CONT_CAPABILITIES_SECONDARY_ANALOG    = (CONT_CAPABILITY_ANALOG2_X |
                                              CONT_CAPABILITY_ANALOG2_Y);

/** \brief Both directional pads (up, down, left right) controller capabilities */
enum CONT_CAPABILITIES_DUAL_DPAD           = (CONT_CAPABILITIES_DPAD |
                                              CONT_CAPABILITIES_SECONDARY_DPAD);

/** \brief Both analog sticks (X, Y axes) controller capabilities */
enum CONT_CAPABILITIES_DUAL_ANALOG         = (CONT_CAPABILITIES_ANALOG | 
                                              CONT_CAPABILITIES_SECONDARY_ANALOG);

/** \brief   Check for controller capabilities
    \ingroup controller_query_caps

    Checks whether or not a controller implements the capabilities 
    associated with the given type. 

    \note
    Controller capability reporting is an extremely generic mechanism, 
    such that many peripherals may implement the same capability in 
    completely different ways. For example, the Samba De Amigo maraca 
    controller will advertise itself as a dual-analog device, with each
    maraca being an analog stick. 

    \param cont            Pointer to a Maple device structure which
                           implements the CONTROLLER function.   
    \param capabilities    Capability mask the controller is expected 
                           to implement

    \retval 1              The controller supports the given capabilities.
    \retval 0              The controller doesn't support the given capabilities.
    \retval -1             Invalid controller. 

    \sa cont_is_type
*/
int cont_has_capabilities(const(maple_device_t)* cont, uint capabilities);


/** \defgroup controller_query_types Querying Types
    \brief    API for determining controller types
    \ingroup  controller

    The following API is for detecting between different types
    of standard controllers. These controllers are not identified
    by specific model but are instead identified solely by capabilities,
    so that homebrew software can remain generic and future-proof to later 
    homebrew controllers or exotic, untested 3rd party peripherals.

    \warning
    Usually you want to check if a controller <i>supports the 
    capabilities</i> of another controller, not whether it is has 
    the <i>exact</i> same capabilities of a controller. For example, 
    a controller that happens to come along supporting a dual analog 
    stick but is otherwise the same layout as a standard controller 
    would not match the standard controller type; however, it would 
    implement its capabilities. There exist 3rd party adapters for 
    connecting dual-analog PS2 controllers to DC which operate 
    like this today.

    \note
    If you really want to hard-code the detection of a certain 
    exact model or brand of controller, instead of basing your
    detection upon capabilities, check for its product_name
    or license within the maple_devinfo structure.

    \sa cont_has_capabilities, maple_devinfo
*/

/** \defgroup controller_types Types
    \brief    Preconfigured capabilities for standard controllers
    \ingroup  controller_query_types

    Aggregate capability mask containing all capabilities 
    which are implemented for a particular controller type.
    For example, the standard controller type is simply a
    combination of the following capabilities:
        - Standard buttons
        - Triggers
        - Dpad
        - Analog
    
    \note
    Because these are technically just capability masks,
    a type may also be passed to cont_has_capabilities() 
    for detecting whether something has <i>at least</i>
    the capabilities of a type.

    @{
*/
/** \brief Standard controller type */
enum CONT_TYPE_STANDARD_CONTROLLER       = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_TRIGGERS |
                                            CONT_CAPABILITIES_DPAD |
                                            CONT_CAPABILITIES_ANALOG);

/** \brief Dual analog controller type */
enum CONT_TYPE_DUAL_ANALOG_CONTROLLER    = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_TRIGGERS |
                                            CONT_CAPABILITIES_DPAD |
                                            CONT_CAPABILITIES_DUAL_ANALOG);

/** \brief ASCII fighting pad controller type */
enum CONT_TYPE_ASCII_PAD                 = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_EXTENDED_BUTTONS |
                                            CONT_CAPABILITIES_DPAD);

/** \brief Arcade stick controller type */
enum CONT_TYPE_ARCADE_STICK              = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_EXTENDED_BUTTONS |
                                            CONT_CAPABILITIES_DPAD);

/** \brief Twin stick joystick controller type */
enum CONT_TYPE_TWIN_STICK                = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_EXTENDED_BUTTONS |
                                            CONT_CAPABILITY_D |
                                            CONT_CAPABILITIES_DUAL_DPAD);

/** \brief ASCII Mission Stick controller type */
enum CONT_TYPE_ASCII_MISSION_STICK       = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_DUAL_DPAD |
                                            CONT_CAPABILITIES_TRIGGERS |
                                            CONT_CAPABILITIES_ANALOG);

/** \brief Racing wheel/controller type */
enum CONT_TYPE_RACING_CONTROLLER         = (CONT_CAPABILITY_DPAD_UP |
                                            CONT_CAPABILITY_DPAD_DOWN |
                                            CONT_CAPABILITY_A |
                                            CONT_CAPABILITY_B |
                                            CONT_CAPABILITY_START |
                                            CONT_CAPABILITIES_TRIGGERS |
                                            CONT_CAPABILITY_ANALOG_X |
                                            CONT_CAPABILITIES_SECONDARY_ANALOG);

/** \brief Samba De Amigo maraca controller type */
enum CONT_TYPE_MARACAS                   = (CONT_CAPABILITY_A |
                                            CONT_CAPABILITY_B |
                                            CONT_CAPABILITY_D |
                                            CONT_CAPABILITY_START |
                                            CONT_CAPABILITIES_EXTENDED_BUTTONS |
                                            CONT_CAPABILITIES_DUAL_ANALOG);

/** \brief Dance Dance Revolution mat controller type */
enum CONT_TYPE_DANCE_MAT                 = (CONT_CAPABILITY_A |
                                            CONT_CAPABILITY_B |
                                            CONT_CAPABILITY_START |
                                            CONT_CAPABILITIES_DPAD);

/** \brief Fishing rod controller type */
enum CONT_TYPE_FISHING_ROD               = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_DPAD |
                                            CONT_CAPABILITIES_TRIGGERS |
                                            CONT_CAPABILITIES_DUAL_ANALOG);

/** \brief Pop'n'Music controller type */
enum CONT_TYPE_POP_N_MUSIC               = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITY_C |
                                            CONT_CAPABILITIES_DPAD);

/** \brief Densha de Go! controller type */
enum CONT_TYPE_DENSHA_DE_GO              = (CONT_CAPABILITIES_STANDARD_BUTTONS |
                                            CONT_CAPABILITIES_EXTENDED_BUTTONS |
                                            CONT_CAPABILITY_D |
                                            CONT_CAPABILITIES_DPAD);
/** @} */


/** \brief   Check for controller type
    \ingroup controller_query_types

    Checks whether or not a controller has the <i>exact</i> 
    capabilities associated with the given type. 

    \warning
    Just becase a controller has all of the same capabilities of a 
    type does not mean that it's that exact type. For example, the
    ASCII Pad and Arcade Stick both implement the same capabilties,
    although they are not the same controllers. They would be 
    indistinguishable here, by design, so that you are able to 
    generalize to a collection of 1st or 3rd party controllers 
    easily.

    \param cont            Pointer to a Maple device structure which
                           implements the CONTROLLER function.   
    \param type            Type identifier or capability mask the
                           controller is expected to match

    \retval 1              The controller matches the given type.
    \retval 0              The controller doesn't match the given type.
    \retval -1             Invalid controller. 

    \sa cont_has_capabilities
*/
int cont_is_type(const(maple_device_t)* cont, uint type);

/* \cond */
/* Init / Shutdown */
int cont_init();
void cont_shutdown();
/* \endcond */