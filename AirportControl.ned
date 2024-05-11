import ned.IdealChannel;
//Imports
import org.omnetpp.queueing.Sink;
import org.omnetpp.queueing.Queue;
import org.omnetpp.queueing.Server;
import org.omnetpp.queueing.Source;
import org.omnetpp.queueing.Classifier;
import org.omnetpp.queueing.Router;
import org.omnetpp.queueing.PassiveQueue;

simple MySourceExt extends Source
{
    @class(MySourceExt);
}

simple MySinkExt extends Sink
{
    @class(MySinkExt);
}

simple Classifier
{
    parameters:
        @group(Queueing);
        @display("i=block/classifier");
        string dispatchField @enum("type","priority") = "type";
    gates:
        input in[];
        output out[];
        output rest; // messages that were not classified
}
simple PassiveQueue
{
    parameters:
        @group(Queueing);
        @signal[dropped](type="long");
        @signal[queueLength](type="long");
        @signal[queueingTime](type="simtime_t");
        @statistic[dropped](title="drop event"; record=vector?,count; interpolationmode=none);
        @statistic[queueLength](title="queue length"; record=vector,timeavg,max; interpolationmode=sample-hold);
        @statistic[queueingTime](title="queueing time at dequeue"; record=vector?,mean,max; unit=s; interpolationmode=none);
        @display("i=block/passiveq;q=queue");
        int capacity = default(-1); // negative capacity means unlimited queue
        bool fifo = default(true); // whether the module works as a queue (fifo=true) or a stack (fifo=false)
        string sendingAlgorithm @enum("priority","random","roundRobin","minDelay") = "roundRobin"; //Changed to roundRobin just to send to random servers, makes routers unnecessary
    	// how the queue tries to find a suitable server for an incoming job
    gates:
        input in[];
        output out[];
}
simple Server
{
    parameters:
        @group(Queueing);
        @display("i=block/server");
        @signal[busy](type="bool");
        @statistic[busy](title="server busy state"; record=vector?,timeavg; interpolationmode=sample-hold);
        string fetchingAlgorithm @enum("priority","random","roundRobin","longestQueue") = "roundRobin"; //Changed to roundRobin just to send to random servers, makes routers unnecessary
        // how the next job will be chosen from the attached queues
        volatile double serviceTime @unit(s); // service time of a job
    gates:
        input in[];
        output out;
}

network AirportControl
{
    @display("bgb=2024.9413,989.8325");
    submodules:
        PrioT_PCT: MySourceExt {
            @display("p=273.00003,207.00002");
        }
        PrioT_PCF: MySourceExt {
            @display("p=273.00003,306.00003");
        }
        PrioF_PCT: MySourceExt {
            @display("p=273.00003,493.50003");
        }
        PrioF_PCF: MySourceExt {
            @display("p=273.00003,591.00006");
        }
        Precheck_Classifier: Classifier {
            @display("p=892.50006,450.00003;is=l");
        }
        sink: MySinkExt {
            @display("p=1618.5001,492.00003");
        }
        PrioF_PQ: PassiveQueue {
            @display("p=441.00003,532.50006");
        }
        PrioF_Server0: Server {
            @display("p=630.00006,391.50003");
        }
        PrioF_Server3: Server {
            @display("p=630.00006,739.50006");
        }
        PrioF_Server2: Server {
            @display("p=630.00006,624.00006");
        }
        PrioF_Server1: Server {
            @display("p=630.00006,510.00003");
        }
        PrioT_PQ: PassiveQueue {
            @display("p=472.50003,244.50002");
        }
        NoPC_PQ: PassiveQueue {
            @display("p=1237.5001,601.50006");
        }
        NoPC_Server0: Server {
            @display("p=1375.5001,450.00003");
        }
        NoPC_Server3: Server {
            @display("p=1375.5001,799.50006");
        }
        NoPC_Server2: Server {
            @display("p=1375.5001,684.00006");
        }
        NoPC_Server1: Server {
            @display("p=1375.5001,567.00006");
        }
        PC_PQ: PassiveQueue {
            @display("p=1237.5001,243.00002");
        }
        PC_Server0: Server {
            @display("p=1375.5001,187.50002");
        }
        PC_Server1: Server {
            @display("p=1375.5001,304.50003");
        }
        PrioT_Server: Server {
            @display("p=630.00006,244.50002");
        }
    connections:
        PrioT_PQ.out++ --> PrioT_Server.in++;
        PrioT_Server.out --> Precheck_Classifier.in++;
        PrioF_Server0.out --> Precheck_Classifier.in++;
        PrioF_Server2.out --> Precheck_Classifier.in++;
        PrioF_Server1.out --> Precheck_Classifier.in++;
        PrioF_Server3.out --> Precheck_Classifier.in++;
        Precheck_Classifier.out++ --> PC_PQ.in++; // JobType = 0, Online Check-In, TSA Precheck
        Precheck_Classifier.out++ --> NoPC_PQ.in++; // JobType = 1, Online Check-In, No Precheck
        Precheck_Classifier.out++ --> PC_PQ.in++; // JobType = 2, Manual Check-In, TSA Precheck
		Precheck_Classifier.rest --> NoPC_PQ.in++; // rest = 4, Manual Check-In, No Precheck (Most Common)
        PrioT_PCT.out --> PrioT_PQ.in++;
        PrioT_PCF.out --> PrioT_PQ.in++;
        PrioF_PCT.out --> PrioF_PQ.in++;
        PrioF_PCF.out --> PrioF_PQ.in++;
        NoPC_PQ.out++ --> NoPC_Server0.in++;
        NoPC_PQ.out++ --> NoPC_Server1.in++;
        NoPC_PQ.out++ --> NoPC_Server2.in++;
        NoPC_PQ.out++ --> NoPC_Server3.in++;
        PrioF_PQ.out++ --> PrioF_Server1.in++;
        PrioF_PQ.out++ --> PrioF_Server0.in++;
        PrioF_PQ.out++ --> PrioF_Server2.in++;
        PrioF_PQ.out++ --> PrioF_Server3.in++;
        PC_PQ.out++ --> PC_Server0.in++;
        PC_PQ.out++ --> PC_Server1.in++;
        PC_Server0.out --> sink.in++;
        PC_Server1.out --> sink.in++;
        NoPC_Server0.out --> sink.in++;
        NoPC_Server1.out --> sink.in++;
        NoPC_Server2.out --> sink.in++;
        NoPC_Server3.out --> sink.in++;
        
}
