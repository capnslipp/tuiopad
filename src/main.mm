
#include "ofMain.h"
#include "testApp.h"
#include "ofAppiPhoneWindow.h"

int main(int argc, char *argv[]) {
	ofAppiPhoneWindow window;
	ofSetupOpenGL(&window, 1024,768, OF_FULLSCREEN);			// <-------- setup the GL context
	ofRunApp(new testApp);
}
