shareslate
==========

HCI class Project. This iOS app and accompanying Python script can be used to allow several clients running iOS 6.1 to connect to a server and edit a document together in real time. 


Instructions:
-------------

If you merely wish to test the functionality of the iOS App, you should download the latest version of xCode, open the project, and run the project on the iPad simulator, and not enter any IP address or port. If you wish to test multiple clients, you should either build and run the app on another computer running xCode, or build and run the app on an iPad 2 or iPad 3 of your own.

Running the server: 
-------------------

To run the server, open a terminal window, CD to the ShareSlate directory, and type "python shareSlateServer.py". If you have a preferred method of running Python scripts, it almost certainly will work equally well.  

Connecting to the server
------------------------

When connecting to the server on a simulator running on the same computer, simply type "localhost" as the IP address, and 1700 as the port. If you are connecting from another computer or an iPad, you must determine the IP address of your computer. The easiest way to do this is to Google "my ip address" which will cause google to tell you your ip. The port is still 1700.

Troubleshooting connections:
---------------------------

If you kill the python script and immediately relaunch it, its port may still be in use, and it will crash, with an error message stating that the port is unavailable. In this event, either wait 10 or 20 seconds, or change the port to another number with a similar magnitude and try again. The port is specified on line 26 of shareSlateServer.py -- "reactor.listenTCP(1700, factory)". 

Presently, the only indication that a connection has failed is a log to the console. 

Known Issues:
-------------
The connection view which first greets users is not the best design for non technical users who likely don't know what an IP address or port is. We would hope to either have a web server with a static IP that the applicaiton can be hard-coded to connect to, or a server browser of sorts. 


No matter what image is selected from the camera roll, the image which is drawn is a gray background image. This is because of the headaches involved in sending an image over a network. 

Version control tableview selection should change with the sliding view and vice-versa, not yet implemented. 

Working UI additions do not work over the network -- one cannot send color info or brush size info.

Programming issues: As should be expected from a slapped-together protoype, this project is an absolute catastrophe in terms of Object-Oriented-Design, memory management, efficiency, and providing feedback when things go wrong on the programming side. This is the result of trying to get it together in time for the deadline of Tuesday, March 19. 

The brush size previewer is hard to see, especially on black. It should have an animated dashed line effect. 

Attributions:
-------------
This project uses code from several sources, including:

Apple's GLPaint sample application: http://developer.apple.com/library/ios/#samplecode/GLPaint/Introduction/Intro.html

DVSlideViewController: https://github.com/dickverbunt/DVSlideViewController (In fact, we no longer use any code from this project, but reading it was extremely helpful)

Ray Wenderlich's tutorial on setting up a python server for an iOS app: http://www.raywenderlich.com/3932/how-to-create-a-socket-based-iphone-app-and-server

The NP color picker https://github.com/neopixl/NPColorPicker/tree/master/ColorPicker
