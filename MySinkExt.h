#ifndef __MYSINKEXT_H__
#define __MYSINKEXT_H__
#include <omnetpp.h>
#include "Sink.h"

using namespace omnetpp;
class MySinkExt : public queueing::Sink{
protected:
    cHistogram PrioT_PCT_Hist;
    cHistogram PrioT_PCF_Hist;
    cHistogram PrioF_PCT_Hist;
    cHistogram PrioF_PCF_Hist;
    cHistogram PrioF_Hist;
    cHistogram PrioT_Hist;
    cHistogram PCF_Hist;
    cHistogram PCT_Hist;
    cHistogram Overall_Hist;

    //We may not need this
//    cStdDev PrioT_PCT_Stats;
//    cStdDev PrioT_PCF_Stats;
//    cStdDev PrioF_PCT_Stats;
//    cStdDev PrioF_PCF_Stats;
//    cStdDev PrioF_Stats;
//    cStdDev PrioT_Stats;
//    cStdDev PCF_Stats;
//    cStdDev PCT_Stats;
//    cStdDev Overall_Stats;

    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void finish();
};

#endif
