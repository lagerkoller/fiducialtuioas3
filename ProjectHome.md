# Important: The work for fiducialtuioas3 is discontinued. If you are starting a new project, consider using our new AS3 Tuio library [Tuio AS3](http://bubblebird.at/tuioflash/tuio-as3-library/). As you most certainly came here because you want to use fiducials in AS3 find the according [Tuio AS3 fiducial howto here](http://bubblebird.at/tuioflash/guides/using-fiducials-with-tuio-as3/). #

This comprehensive fiducial as 3 framework enhances the [Touchlib's](http://code.google.com/p/touchlib/) [AS3 classes](http://code.google.com/p/touchlib/source/browse/#svn/trunk/AS3) with Tuio object interaction functionality.

**If you run into problems while testing fiducialtuioas3 with the TUIOSimulator: please enable "Options → Periodic Messages" in the simulator.**

The  adapted Touchlib's TUIO AS3 classes are included. To make it even clearer: You don't need any other TUIO AS3 classes then those of fiducialtuioas3 as fiducialtuioas3 supports both multi-touch AND fiducials. It's complete. You can even use fiducialtuioas3 if you only want to implement multi-touch interaction.

There are two versions of fiducialtuioas3:
  * _Standard_ fiducialtuioas3 that runs in combination with Flosc.
  * _TCP version_ of fiducialtuioas3 that runs in combination [with a UDP to TCP bridge like that of Mehmet Akten](http://www.memo.tv/cross_platform_open_source_udp_tcp_bridge_for_osc_tuio_etc). This version should have a better performance than the standard version with as all this XML generation and parsing is obsolete.

In fiducialtuioas3, a TuioManager controls adding, moving, rotation and removing of fiducials on a multi-touch/object interaction setup:
```
TUIO.init(this, "localhost", 3000,"",true);
//TUIOManager dispatches all the fiducial events
tuioManager = new TUIOManager(this);
this.addChild(tuioManager);
```

Fiducials can be used in AS3 by getting a PropObject with a fiducial id (in this case fiducial id #4).
Each PropObject can have one or more handlers for events:
```
//track fiducial #4:
var testProp4:PropObject = tuioManager.getProp(4);
var testPropHandler4:TestFiducialHandler = new TestFiducialHandler();
addChild(testPropHandler4);
testProp.addTUIOPropEventListeners(testPropHandler4);

//track fiducial #5:
var testProp5:PropObject = tuioManager.getProp(5);
var testPropHandler5:TestFiducialHandler = new TestFiducialHandler();
addChild(testPropHandler5);
testProp.addTUIOPropEventListeners(testPropHandler5);

//also track fiducial #160:
var testProp160:PropObject = tuioManager.getProp(160);
var testPropHandler160:TestFiducialHandler = new TestFiducialHandler();
addChild(testPropHandler160);
testProp.addTUIOPropEventListeners(testPropHandler160);
```

... and so on. just add those 4 lines for every fiducial you want to track.

pretty easy, isn't it?

however, if you want different things to happen if you add a certain fiducial you will have to write other handlers as compared to the TestFiducialHandler. just cut and paste things from TestFiducialHandler and change to your taste.

It it most likely that you want to use fiducialtuioas3 in combination with reacTIVision (http://reactivision.sourceforge.net/).

Vispol is an example project that has been created with this framework:

<a href='http://www.youtube.com/watch?feature=player_embedded&v=_2DywsIPNDQ' target='_blank'><img src='http://img.youtube.com/vi/_2DywsIPNDQ/0.jpg' width='425' height=344 /></a>

(More information about [Vispol tangible interaction](http://johannesluderschmidt.de/lang/en-us/vispol-tangible-and-multi-touch-interface-video/474/).)

Another great example video of what has been done with this framework can be seen [here](http://johannesluderschmidt.de/lang/en-us/pf-design-media-installation/452).