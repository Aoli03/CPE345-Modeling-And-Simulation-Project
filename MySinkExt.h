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

    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
    virtual void finish();
};

#endif
