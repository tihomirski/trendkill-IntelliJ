package model;

import rule.Reasoner;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * This object will hold all the candles within the time frame.
 * Within the time frame, one can have various candles.
 * That is, within 1 hour, one can have candles of 20 seconds, 1 minute, 5 minutes, 15 minutes, etc.
 * That will give more information to the reasoner.
 */
public class TimeFrame {

    long period;
    private List<Candle> candles;
    /**
     * The list of "local minimums".
     */
    private List<Float> lows;
    /**
     * The list of "local maximums".
     */
    private List<Float> highs;
    /**
     * The piece of program that will make decisions of what to do.
     * Potentially, can become a list of reasoners.
     * If you have more reasoners and all of them are telling you to sell (or buy), the more confident you will be to sell (or buy).
     * You can make some kind of combination between them. Perhaps also weighting them.
     */
    private Reasoner reasoner;
    long timeToOpenNewCandle;

    public TimeFrame(long period, Reasoner reasoner) {
        this.period = period;
        candles = new ArrayList<>();
        this.reasoner = reasoner;
    }

    public void addTick(Tick tick) {
        if (candles.size() > 0) {
            Candle lastCandle = candles.get(candles.size()-1);
            if(tick.getTimestamp().getTime() < timeToOpenNewCandle) {
                lastCandle.addTick(tick);
            } else {
                lastCandle.setClosePrice(tick.getSellPrice());
                Candle candle = new Candle(tick, period);
                candles.add(candle);
                timeToOpenNewCandle += period;
            }
        } else {
            Candle candle = new Candle(tick, period);
            candles.add(candle);
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(tick.getTimestamp().getTime());
            cal.set(Calendar.MILLISECOND, 0);
            timeToOpenNewCandle = cal.getTimeInMillis() + period;
        }

    }
}
