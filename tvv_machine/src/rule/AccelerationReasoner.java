package rule;

public class AccelerationReasoner implements Reasoner {
    @Override
    public void openPosition() {
        System.out.println("Open position");
    }

    @Override
    public void closePosition() {
        System.out.println("Close position");
    }

    /**
     * TODO - Implement an acceleration reasoner
     *
     * This class has to detect a big acceleration.
     * When this happens, you will know that a trend begins or that some big volatility happens.
     */


}
