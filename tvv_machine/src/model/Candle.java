package model;

import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class Candle {

    private float openPrice;
    private float closePrice;
    private float highPrice;
    private float lowPrice;
    private float averagePrice;
    private List<Tick> ticks = new LinkedList<>();
    /**
     * What is this??
     */
    private long period;
    private Date openTime;

    public Candle(Tick tick, long period) {
        this.openPrice = tick.getSellPrice();
        this.highPrice = tick.getSellPrice();
        this.lowPrice = tick.getSellPrice();
        this.period = period;
        this.openTime = tick.getTimestamp();
        this.averagePrice = tick.getSellPrice();
        ticks.add(tick);
    }

    public float getOpenPrice() {
        return openPrice;
    }

    public void setOpenPrice(float openPrice) {
        this.openPrice = openPrice;
    }

    public float getClosePrice() {
        return closePrice;
    }

    public void setClosePrice(float closePrice) {
        this.closePrice = closePrice;
    }

    public float getHighPrice() {
        return highPrice;
    }

    public void setHighPrice(float highPrice) {
        this.highPrice = highPrice;
    }

    public float getLowPrice() {
        return lowPrice;
    }

    public void setLowPrice(float lowPrice) {
        this.lowPrice = lowPrice;
    }

    public float getAveragePrice() {
        return averagePrice;
    }

    public Date getOpenTime() {
        return openTime;
    }

    /**
     * Working with the sell price. It can be tuned later.
     * @param tick The new tick to be added to this candle.
     */
    public void addTick(Tick tick) {
        ticks.add(tick);
        averagePrice = calculateAvg();
        if (tick.getSellPrice() > highPrice) {
            highPrice = tick.getSellPrice();
        }
        if (tick.getSellPrice() < lowPrice) {
            lowPrice = tick.getSellPrice();
        }
    }

    /**
     * Calculate the average of the sell prices.
     * Why sell prices?!? Just to start with something. You can tune it later.
     * @return The average of the sell price. Why the sell price?!? Just to start with something. It can be tuned later.
     */
    private float calculateAvg() {
//        return (averagePrice * (ticks.size() - 1) + sellPrice) / ticks.size();
        float sum = 0;
        for (Tick tick : ticks) {
            sum += tick.getSellPrice();
        }

        return sum / ticks.size();
    }

}
