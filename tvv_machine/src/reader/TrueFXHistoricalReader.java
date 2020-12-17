package reader;

import model.Tick;
import model.TimeFrame;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * This reader reads the TrueFX-specific CSV files with all the tick data.
 */
public class TrueFXHistoricalReader implements BasicReader {

    private static DecimalFormat df = new DecimalFormat("0.00");

//    public static void main(String[] args) {
//        try {
//            read();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

    public void read(TimeFrame timeFrame, String path) throws Exception {

        File file = new File(path);
        BufferedReader br = new BufferedReader(new FileReader(file));
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd HH:mm:ss.SSS");

        String st;
        while ((st = br.readLine()) != null) {
//            String currentPrice = st.split(",")[3];
//            float price = Float.parseFloat(currentPrice);
            String[] tickPieces = st.split(",");
            Date time = dateFormat.parse(tickPieces[1]);
            Tick tick = new Tick(tickPieces[0], time, Float.parseFloat(tickPieces[2]), Float.parseFloat(tickPieces[3]));
            timeFrame.addTick(tick);
        }
        int breakpoint = 0;
    }



}
