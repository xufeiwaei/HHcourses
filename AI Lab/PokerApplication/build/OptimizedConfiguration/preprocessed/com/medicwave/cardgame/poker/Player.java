/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;


/**
 *
 * @author xufei
 */
public class Player {
    private String Name;
    public int CardsThrown;
    public int LastAction;
    public int LastRaised;
    public int NoOfOpens;
    public int NoOfChecks;
    public int NoOfFolds;
    public int NoOfCalls;
    public int NoOfRaises;
    public int NoOfAllIns;
    public int Chips;
    public boolean InRound;
    public boolean Thrown;
    public int Position;
    public double Aggresitivity;

    public Player( String Name, int Position )
    {
        this.Name = Name;
        this.NoOfOpens = 0;
        this.NoOfChecks = 0;
        this.NoOfFolds = 0;
        this.NoOfCalls = 0;
        this.NoOfAllIns = 0;
        this.NoOfRaises = 0;
        this.LastAction = -1;
        this.LastRaised = 0;
        this.Chips = 200;
        this.InRound = true;
        this.Position = Position;
        this.Thrown = false;
    }
    public String GetName()
    {
        return this.Name;
    }

}
