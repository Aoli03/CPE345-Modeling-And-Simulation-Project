#include <stdio.h>
#include <string.h>
#include <omnetpp.h>
#include "Job.h"

using namespace omnetpp;

class Source : public cSimpleModule
{

protected:
    virtual queueing::Job *createJob();
    virtual double getInterArrivalTime();
    virtual void initialize() override;
    virtual void handleMessage(cMessage*msg) override;
};

Define_Module(Source);

void Source::initialize(){
    scheduleAt(0, new cMessage("newJobTimer"));
}

void Source::handleMessage(cMessage *msg)
{
    ASSERT(msg->isSelfMessage());

        if (simTime().dbl() < 86400) {
            // reschedule the timer for the next message
            scheduleAt(simTime() + getInterArrivalTime(), msg);
            queueing::Job *job = createJob();
            send(job, "out");
            EV << simTime();
        }
        else {
            // finished
            delete msg;
        }
}

double Source::getInterArrivalTime(){
    //New stuff
    double probArrival = par("probArrival");
    double interarrivalRateRush = par("interarrivalRateRush");
    double interarrivalRateNormal = par("interarrivalRateNormal");
    int numberOfPeaks = par("numberOfPeaks");
    double durationOfPeaks = par("durationOfPeaks");

    //All math is in seconds
    std::vector<simtime_t> peaks;
    for (int i = 1; i <= numberOfPeaks; i++) {
            peaks.push_back(i*86400.0/(numberOfPeaks+1)-durationOfPeaks/2);
            peaks.push_back(i*86400.0/(numberOfPeaks+1)+durationOfPeaks/2);
    }
    for (int i = 0; i < peaks.size(); i+=2) {
        if (simTime()/60 >= peaks[i] && simTime()/60 <= peaks[i+1]) {
            return interarrivalRateRush/probArrival;
        }
    }
    return interarrivalRateNormal/probArrival;
}

queueing::Job *Source::createJob() {
    queueing::Job *job = new queueing::Job();
    job->setKind(par("jobType"));
    job->setPriority(0);
    return job;
}
