/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.medicwave.cardgame.poker;

import ca.ualberta.cs.poker.Card;
import ca.ualberta.cs.poker.Hand;

/**
 *
 * @author Jonas
 */
public class Round
{
    public int RoundNb;

    private Hand hand;

    private int [] Cards;

    private int Rank;

    public int [] CardsInDeck;

    public int CurrentBet;

    public int MyBet;

    public boolean CardsThrown;

    /* Evaluate */
    public double BestRank;
    public int [] CardsToThrow;

    public Round( int round )
    {
        RoundNb = round;
        
        Cards = new int[ 5 ];

        CardsInDeck = new int[ 52 ];

        CurrentBet = 0;

        CardsThrown = false;

        Rank = -1;
    }

    public void SetHand(Hand hand)
    {
        this.hand = hand;
    }

    public Card GetCardFromPos(int pos)
    {
        return hand.getCard( pos );
    }

    public void SetCards(int [] c, int r)
    {
        Cards = c;
        Rank = r;
        BestRank = 1-r/7462.0;
    }

    public int [] GetCards()
    {
        return Cards;
    }

    public int GetRank()
    {
        return Rank;
    }

    public boolean CardInDeck( int CardNb )
    {
        if( CardsInDeck[ CardNb ] == 1 )
        {
            return false;
        }

        return true;
    }

    public boolean CardInDeck( int Suit, int Value )
    {
        return this.CardInDeck( Suit*13 + Value );
    }
}


