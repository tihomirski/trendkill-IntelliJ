package come.example;

import model.Candle;
import model.Tick;
import org.mockito.Mock;
import org.testng.annotations.Test;
import reader.BasicReader;

import java.util.Date;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertTrue;

public class TestFirstExample {

    @Mock
    BasicReader reader;

    @Test
    public void test() {
        System.out.println("Asserting true the <true>");
        assertTrue(true);
    }

    @Test
    public void testAddTickToCandleAndFindAverage() {
        Tick tick = new Tick("EURUSD", new Date(), 1.1601f,1.1602f);
        Candle candle = new Candle(tick, 60);
        try {
            Thread.sleep(335);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        Tick anotherTick = new Tick("EURUSD", new Date(), 1.1604f,1.1605f);
        candle.addTick(anotherTick);

        /**
         * The candle is working with the sell prices, for now.
         */
        assertEquals(candle.getAveragePrice(), 1.16025f);
    }

}
