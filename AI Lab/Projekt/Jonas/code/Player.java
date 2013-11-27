/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

/**
 *
 * @author Jonas
 */
public class Player {
    
    private String name;

    public boolean InRound;

    /* All rounds in one game */
    public int Open;
    public int Check;
    public int Call;
    public int Raise;
    public int Fold;
    public int Allin;

    /* Info about current round */
    public int CardsThrown;
    public int LastAction;    
    public int Chips;

    public double PlayMode;

    public int Position;
    
    public Player( String name, int pos )
    {
        this.name = name;
        InRound = true;

        Open = 0;
        Check = 0;
        Call = 0;
        Raise = 0;
        Fold = 0;
        Allin = 0;

        Chips = 200;
        LastAction = -1;

        Position = pos;

    }

    public String GetName()
    {
        return name;
    }

    public void NewRound()
    {
        CardsThrown = 0;
        LastAction = 0;
        Chips = 0;
    }

}
