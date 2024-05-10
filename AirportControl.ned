import ned.IdealChannel;
//Imports
import org.omnetpp.queueing.Sink;
import org.omnetpp.queueing.Queue;
//import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Server;
import org.omnetpp.queueing.Source;
import org.omnetpp.queueing.Classifier;
import org.omnetpp.queueing.Router;

simple Classifier
{
    parameters:
        @group(Queueing);
        @display("i=block/classifier");
        string dispatchField @enum("type","priority") = default("type");
    gates:
        input in[];
        output out[];
        output rest; // messages that were not classified
}
//simple PassiveQueue
//{
//    parameters:
//        @group(Queueing);
//        @signal[dropped](type="long");
//        @signal[queueLength](type="long");
//        @signal[queueingTime](type="simtime_t");
//        @statistic[dropped](title="drop event"; record=vector?,count; interpolationmode=none);
//        @statistic[queueLength](title="queue length"; record=vector,timeavg,max; interpolationmode=sample-hold);
//        @statistic[queueingTime](title="queueing time at dequeue"; record=vector?,mean,max; unit=s; interpolationmode=none);
//        @display("i=block/passiveq;q=queue");
//        int capacity = default(-1); // negative capacity means unlimited queue
//        bool fifo = default(true); // whether the module works as a queue (fifo=true) or a stack (fifo=false)
//        string sendingAlgorithm @enum("priority","random","roundRobin","minDelay") = default("priority");
//    // how the queue tries to find a suitable server for an incoming job
//    gates:
//        input in[];
//        output out[];
//}
simple Server
{
    parameters:
        @group(Queueing);
        @display("i=block/server");
        @signal[busy](type="bool");
        @statistic[busy](title="server busy state"; record=vector?,timeavg; interpolationmode=sample-hold);
        string fetchingAlgorithm @enum("priority","random","roundRobin","longestQueue") = default("priority");
        // how the next job will be chosen from the attached queues
        volatile double serviceTime @unit(s); // service time of a job
    gates:
        input in[];
        output out;
}

network PriorityQueueing
{
    @display("bgb=1245,615");
    submodules:
        PrioT_PCT: Source {
            @display("p=53,251");
        }
        PrioT_PCF: Source {
            @display("p=53,316");
        }
        PriorityCheckIn_Classifier: Classifier {
            @display("p=170,352;is=l");
        }
        PrioT_Router: Router {
            @display("p=278,196");
        }
        PrioF_Router: Router {
            @display("p=278,352");
        }
        PrioT_Q1: Queue {
            @display("p=396,196");
        }
        PrioF_Q0: Queue {
            @display("p=396,283");
        }
        PrioF_Q1: Queue {
            @display("p=396,347");
        }
        PrioF_Q2: Queue {
            @display("p=396,410");
        }
        PrioF_Q3: Queue {
            @display("p=396,469");
        }
        PrioF_PCT: Source {
            @display("p=53,379");
        }
        PrioF_PCF: Source {
            @display("p=53,442");
        }
        PCF_Router: Router {
            @display("p=632,421");
        }
        Precheck_Classifier: Classifier {
            @display("p=536,352;is=l");
        }
        PCT_Router: Router {
            @display("p=632,218");
        }
        PCT_Q0: Queue {
            @display("p=734,179");
        }
        PCT_Q1: Queue {
            @display("p=734,244");
        }
        PCF_Q0: Queue {
            @display("p=734,318");
        }
        PCF_Q1: Queue {
            @display("p=734,382");
        }
        PCF_Q2: Queue {
            @display("p=734,445");
        }
        PCF_Q3: Queue {
            @display("p=734,504");
        }
        sink: Sink {
            @display("p=864,318");
        }
    connections:
        PrioT_PCT.out --> IdealChannel --> PriorityCheckIn_Classifier.in++;
        PrioT_PCF.out --> IdealChannel --> PriorityCheckIn_Classifier.in++;
        PrioF_PCT.out --> IdealChannel --> PriorityCheckIn_Classifier.in++;
        PrioF_PCF.out --> IdealChannel --> PriorityCheckIn_Classifier.in++;
        PriorityCheckIn_Classifier.out++ --> IdealChannel --> PrioT_Router.in++;
        PriorityCheckIn_Classifier.rest --> IdealChannel --> PrioF_Router.in++;
        PrioT_Router.out++ --> IdealChannel --> PrioT_Q1.in++;
        PrioF_Router.out++ --> IdealChannel --> PrioF_Q0.in++;
        PrioF_Router.out++ --> IdealChannel --> PrioF_Q1.in++;
        PrioF_Router.out++ --> IdealChannel --> PrioF_Q2.in++;
        PrioF_Router.out++ --> IdealChannel --> PrioF_Q3.in++;
        PrioF_Q0.out --> IdealChannel --> Precheck_Classifier.in++;
        PrioT_Q1.out --> IdealChannel --> Precheck_Classifier.in++;
        PrioF_Q1.out --> IdealChannel --> Precheck_Classifier.in++;
        PrioF_Q2.out --> IdealChannel --> Precheck_Classifier.in++;
        PrioF_Q3.out --> IdealChannel --> Precheck_Classifier.in++;
        Precheck_Classifier.out++ --> IdealChannel --> PCT_Router.in++;
        Precheck_Classifier.rest --> IdealChannel --> PCF_Router.in++;
        PCT_Router.out++ --> IdealChannel --> PCT_Q0.in++;
        PCT_Router.out++ --> IdealChannel --> PCT_Q1.in++;
        PCF_Router.out++ --> IdealChannel --> PCF_Q0.in++;
        PCF_Router.out++ --> IdealChannel --> PCF_Q1.in++;
        PCF_Router.out++ --> IdealChannel --> PCF_Q2.in++;
        PCF_Router.out++ --> IdealChannel --> PCF_Q3.in++;
        PCT_Q0.out --> IdealChannel --> sink.in++;
        PCT_Q1.out --> IdealChannel --> sink.in++;
        PCF_Q0.out --> IdealChannel --> sink.in++;
        PCF_Q1.out --> IdealChannel --> sink.in++;
        PCF_Q2.out --> IdealChannel --> sink.in++;
        PCF_Q3.out --> IdealChannel --> sink.in++;
}
