This sample demonstrates the use of the BDHoverViewController.  BDHoverViewController provides a modal view with shadow, that enables you to show the user that an activity such as internet access or long task is ongoing and that interacting with the user interface is not possible.  There are four different versions of the hoverView:

1.  Exclusive Touch where only a UIView with alpha of 0.1 is shown.
2.  An exclusive touch UIView with a UIActivityIndicator
3.  An exclusive tough UIView with a UIActivityIndicator and UILabel for status.
4.  An exclusive touch UIView with a UIActivityIndicator, UILabel for status, and a UIProgressView

BDHoverViewController makes extensive use of blocks in order to build the animations for transitions from one hoverView style to the other.  The use of NSMutableArray and blocks allow the building of the animations on the fly.

**Notes:**  As of 10/14/2011, BDHoverview has been converted to Automatic Reference Counting and will only work on iOS5 and greater.

The Activity only style looks like this:
![screenshot](https://github.com/toolmanGitHub/BDHoverViewController/raw/master/activityScreenShot.png)

The Activity with Status Label style looks like this:
![screenshot](https://github.com/toolmanGitHub/BDHoverViewController/raw/master/statusScreenShot.png)

The Activity, Status, and Progress style looks like this:
![screenshot](https://github.com/toolmanGitHub/BDHoverViewController/raw/master/progressScreenShot.png)

**Notes:**  As of 10/14/2011, BDHoverview has been converted to Automatic Reference Counting and will only work on iOS5 and greater.

License

The below license is the new BSD license with the OSI recommended personalizations.
 <http://www.opensource.org/licenses/bsd-license.php>
 
 Copyright (C) 2011 Big Diggy SW. All Rights Reserved.
 
 Redistribution and use in source and binary forms, with or without  modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice,  this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 * Neither the name of Tim Taylor nor Big Diggy SW may be used to endorse or promote products derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY Big Diggy SW "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
