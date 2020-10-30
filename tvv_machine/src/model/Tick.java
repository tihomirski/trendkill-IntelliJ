package model;

import java.util.Date;

public class Tick {

    private String pair;
    private Date timestamp;
    private float sellPrice;
    private float buyPrice;

    public Tick(String pair, Date timestamp, float sellPrice, float buyPrice) {
        this.pair = pair;
        this.timestamp = timestamp;
        this.sellPrice = sellPrice;
        this.buyPrice = buyPrice;
    }

    public String getPair() {
        return pair;
    }

    public void setPair(String pair) {
        this.pair = pair;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public float getSellPrice() {
        return sellPrice;
    }

    public void setSellPrice(float sellPrice) {
        this.sellPrice = sellPrice;
    }

//    public float getBuyPrice() {
//        return buyPrice;
//    }
//
//    public void setBuyPrice(float buyPrice) {
//        this.buyPrice = buyPrice;
//    }
}
