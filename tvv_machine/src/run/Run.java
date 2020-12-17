package run;

import model.TimeFrame;
import reader.TrueFXHistoricalReader;
import rule.AccelerationReasoner;
import rule.Reasoner;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class Run {

    public static void main(String[] args) throws IOException {
        initFrame();
//        System.out.println(generateSample());
    }

    public static void initFrame() {
        TrueFXHistoricalReader reader = new TrueFXHistoricalReader();
        List<Reasoner> reasoners =  new ArrayList<>();
        Reasoner reasoner = new AccelerationReasoner();
        List<Reasoner> instrumentReasoners = getPopularIndicators();
        reasoners.add(reasoner);

        long period = 3 * 1000;
        TimeFrame window = new TimeFrame(period, reasoners);
        try {
            reader.read(window, "/home/tihomirski/Tihomir/Gazela/trendkill/truefx_com/DataSamples/sample-EURUSD-200-300.csv");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static List<Reasoner> getPopularIndicators() {
        return null;
    }

    public static String generateSample() throws IOException {
        int millis = 200;
        int tickLimitInMinutes = (1000 / millis) * 60 * 1;
        String path = "/home/tihomirski/Tihomir/Gazela/trendkill/truefx_com/DataSamples/";

        int minute = 0;

        String fileName = "sample-EURUSD-" + millis + "-" + tickLimitInMinutes + ".csv";
        FileWriter fileWriter = new FileWriter(path + fileName);
        PrintWriter printWriter = new PrintWriter(fileWriter);

        double sellPrice = 1.21200;
        for (int i=0; i<tickLimitInMinutes; i++) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd HH:mm:ss.SSS");
            LocalDateTime ldt = LocalDateTime.now().plusMinutes(2);
            DateTimeFormatter formmat1 = DateTimeFormatter.ofPattern(dateFormat.toPattern(), Locale.ENGLISH);
            String formattedDate = formmat1.format(ldt);

            StringBuilder line = new StringBuilder("EUR/USD,");
            line
                    .append(formattedDate)
                    .append(",")
                    .append(String.format("%.5f", sellPrice))
                    .append(",")
                    .append(String.format("%.5f", sellPrice + 0.00015));
            printWriter.println(line.toString());
            System.out.println(line.toString());

            sellPrice = (sellPrice + 0.00010) + (i * 0.00001);
        }

        printWriter.close();

        return path + fileName;
    }

}
