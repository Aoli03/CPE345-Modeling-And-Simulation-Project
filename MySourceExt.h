#ifndef __MYSOURCEEXT_H__
#define __MYSOURCEEXT_H__
#include <omnetpp.h>
#include "Source.h"

using namespace omnetpp;
class MySourceExt : public queueing::Source{
protected:
    virtual void initialize();
    virtual void handleMessage(cMessage *msg);
};

#endif
