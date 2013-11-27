package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.Hand;
import java.util.Hashtable;
import java.util.Vector;





class Round {
    private Vector _playerNames;    // Vector<String>
    // String(playerName) -> RoundInfo
    private Hashtable _roundInfo;
    
    private int _roundNr;
    private int _currentAnte;
    private int _currentPot;
    private int _lastRaise;
    
    public Round(int roundNr) {
        _playerNames = new Vector();
        _roundNr = roundNr;
        _roundInfo = new Hashtable();
    }
    
    void initPlayer(String playerName) {
        _roundInfo.put(playerName, new RoundInfo());
        _playerNames.addElement(playerName);
    }

    public Vector getPlayerNames() {
        return _playerNames;
    }
    
    public void setPlayerChips(String playerName, int chips) {
        RoundInfo ri = (RoundInfo)_roundInfo.get(playerName);
        ri.setChips(chips);
    }
    
    public int getPlayerChips(String playerName) {
        RoundInfo ri = (RoundInfo)_roundInfo.get(playerName);
        return ri.getChips();
    }
    
    public RoundInfo getRoundInfo(String playerName) {
        RoundInfo ri = (RoundInfo)_roundInfo.get(playerName);
        return ri;
    }

    /**
     * @return Return current round number.
     */
    public int getRoundNr() {
        return _roundNr;
    }

    public void setCurrentAnte(int ante) {
        _currentAnte = ante;
    }
    
    public int getCurrentAnte() {
        return _currentAnte;
    }

    int getPot() {
        return _currentPot;
    }

    void addToPot(int betAmount) {
        _currentPot += betAmount;
        System.out.print("_currentPot=" + _currentPot + " betAmount=" + betAmount);
    }

    /**
     * @return the _lastRaise
     */
    public int getLastRaise() {
        return _lastRaise;
    }

    /**
     * @param lastRaise the _lastRaise to set
     */
    public void setLastRaise(int lastRaise) {
        _lastRaise = lastRaise;
    }
}

class RoundInfo {
    private int _chips;
    private int _nrTimesRaised;
    private int _nrTimesChecked;
    private int _nrTimesCalled;
    private boolean _allIn;
    private boolean _fold;
    private Vector _raises;
    private int _nrCardsDrawn;
    private Hand _hand;
    private int _roundWinAmount;
    private boolean _undisputedWin;
    
    public RoundInfo() {
        _raises = new Vector();
        _allIn = false;
        _fold = false;
        _undisputedWin = false;
    }
    /**
     * @return the _chips
     */
    public int getChips() {
        return _chips;
    }

    /**
     * @param chips the _chips to set
     */
    public void setChips(int chips) {
        _chips = chips;
    }

    /**
     * @return the _nrTimesRaised
     */
    public int getNrTimesRaised() {
        return _nrTimesRaised;
    }

    /**
     * @param nrTimesRaised the _nrTimesRaised to set
     */
    public void setNrTimesRaised(int nrTimesRaised) {
        _nrTimesRaised = nrTimesRaised;
    }

    /**
     * @return the _nrTimesChecked
     */
    public int getNrTimesChecked() {
        return _nrTimesChecked;
    }

    /**
     * @param nrTimesChecked the _nrTimesChecked to set
     */
    public void setNrTimesChecked(int nrTimesChecked) {
        _nrTimesChecked = nrTimesChecked;
    }

    /**
     * @return the _allIn
     */
    public boolean isAllIn() {
        return _allIn;
    }

    /**
     * @param allIn the _allIn to set
     */
    public void setAllIn(boolean allIn) {
        _allIn = allIn;
    }

    /**
     * @return the _fold
     */
    public boolean isFold() {
        return _fold;
    }

    /**
     * @param fold the _fold to set
     */
    public void setFold(boolean fold) {
        _fold = fold;
    }
    
    /**
     * @return the _nrTimesCalled
     */
    public int getNrTimesCalled() {
        return _nrTimesCalled;
    }

    /**
     * @param nrTimesCalled the _nrTimesCalled to set
     */
    public void setNrTimesCalled(int nrTimesCalled) {
        _nrTimesCalled = nrTimesCalled;
    }

    /**
     * @return the _nrCardsDrawn
     */
    public int getNrCardsDrawn() {
        return _nrCardsDrawn;
    }

    /**
     * @param nrCardsDrawn the _nrCardsDrawn to set
     */
    public void setNrCardsDrawn(int nrCardsDrawn) {
        _nrCardsDrawn = nrCardsDrawn;
    }

    /**
     * @return the _hand
     */
    public Hand getHand() {
        return _hand;
    }

    /**
     * @param hand the _hand to set
     */
    public void setHand(Hand hand) {
        _hand = hand;
    }
    
    /**
     * @return the _roundWinAmount
     */
    public int getRoundWinAmount() {
        return _roundWinAmount;
    }

    /**
     * @param roundWinAmount the _roundWinAmount to set
     */
    public void setRoundWinAmount(int roundWinAmount) {
        _roundWinAmount = roundWinAmount;
    }

    /**
     * @return the _undisputedWin
     */
    public boolean isUndisputedWin() {
        return _undisputedWin;
    }

    /**
     * @param undisputedWin the _undisputedWin to set
     */
    public void setUndisputedWin(boolean undisputedWin) {
        _undisputedWin = undisputedWin;
    }

    /**
     * Add an amount that the user raised.
     * @param amount 
     */
    public void addRaise(int amount) {
        _raises.addElement(new Integer(amount));
    }
    
    public Vector getRaises() {
        return _raises;
    }
}

public class PokerGame {
    private Vector _rounds;    // Vector<Round>
    private int _currentRound;
    
    public PokerGame() {
        _rounds = new Vector();
        _currentRound = 0;
    }
    
    public void newRound() {
        _rounds.addElement(new Round(_currentRound++));
    }

    Round currentRound() {
        return (Round)_rounds.elementAt(_currentRound - 1);
    }
}
