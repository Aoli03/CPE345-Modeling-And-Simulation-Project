#include "MySourceExt.h"

Define_Module(MySourceExt);
void MySourceExt::initialize(){
    Source::initialize();
}
void MySourceExt::handleMessage(cMessage *msg){
    simtime_t delay = simTime()-msg -> getTimestamp();
    Source::handleMessage(msg);
}
