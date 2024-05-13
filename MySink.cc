#include "MySinkExt.h"
Define_Module(MySinkExt);
void MySinkExt::initialize(){
    PrioT_PCT_Hist.setName("PrioT_PCT_Hist");
    PrioT_PCF_Hist.setName("PrioT_PCF_Hist");
    PrioF_PCT_Hist.setName("PrioF_PCT_Hist");
    PrioF_PCF_Hist.setName("PrioF_PCF_Hist");
    PrioF_Hist.setName("PrioF_Hist");
    PrioT_Hist.setName("PrioT_Hist");
    PCF_Hist.setName("PCF_Hist");
    PCT_Hist.setName("PCT_Hist");
    Overall_Hist.setName("Overall_Hist");
    Sink::initialize();
}
void MySinkExt::handleMessage(cMessage *msg){
    int jobType = msg->getKind();
    simtime_t delay = simTime()-msg -> getTimestamp();

    // jobType = 0, Online Check-In, TSA Precheck
    if(jobType == 0){
        PrioT_PCT_Hist.collect(delay);
        PrioT_Hist.collect(delay);
        PCT_Hist.collect(delay);
    }
    // jobType = 1, Online Check-In, No Precheck
    else if(jobType == 1){
        PrioT_PCF_Hist.collect(delay);
        PrioT_Hist.collect(delay);
        PCF_Hist.collect(delay);
    }
    // jobType = 2, Manual Check-In, TSA Precheck
    else if(jobType == 2){
        PrioF_PCT_Hist.collect(delay);
        PrioF_Hist.collect(delay);
        PCT_Hist.collect(delay);
    }
    // jobType = 4, Manual Check-In, No Precheck (Most Common)
    else if(jobType == 3){
        PrioF_PCF_Hist.collect(delay);
        PrioF_Hist.collect(delay);
        PCF_Hist.collect(delay);
    }

    Overall_Hist.collect(delay);

    Sink::handleMessage(msg);
}
void MySinkExt::finish(){
    PrioT_PCT_Hist.record();
    PrioT_PCF_Hist.record();
    PrioF_PCT_Hist.record();
    PrioF_PCF_Hist.record();
    PrioF_Hist.record();
    PrioT_Hist.record();
    PCF_Hist.record();
    PCT_Hist.record();
    Overall_Hist.record();
    Sink::finish();
}


