package run;

import model.TimeFrame;
import reader.TrueFXHistoricalReader;
import rule.AccelerationReasoner;
import rule.Reasoner;

public class Run {

    public static void main(String[] args) {
        TrueFXHistoricalReader reader = new TrueFXHistoricalReader();
        Reasoner reasoner = new AccelerationReasoner();
        long period = 3 * 1000;
        TimeFrame window = new TimeFrame(period, reasoner);
        try {
            reader.read(window, "/home/tihomirski/Tihomir/Gazela/trendkill/truefx_com/eurusd-2107-02-sample.csv");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
