/*
 * This class is used to evaluate playstyles of a player.
 */

package com.medicwave.cardgame.poker;

import java.util.Enumeration;
import java.util.Hashtable;

public class PlayStyle {

    public static double FOLD = 0.0;
    public static double CHECK = 0.4;
    public static double CALL = 0.5;
    public static double OPEN = 0.7;
    public static double RAISE = 0.8;
    public static double ALLIN = 1.0;
    public static double START_VAL = 0.5;
    public static double LEARN_RATE = 4.0;

    public static double CalcPlayStyle( Player p, int Round )
    {
        /* Calculate the aggresitivity of a player, give the value some rounds
         * to tune itself. A lot of all ins and raises gives an aggressive
         * player. Don't take an aggressive player's raises as serious as a
         * defensive player's raises.
         *
         * Returns a value between 0 and 1 where 0 is more defensive than 1.
         */
        double Aggr = ( START_VAL + p.NoOfFolds*FOLD + p.NoOfChecks*CHECK + p.NoOfCalls*CALL + p.NoOfOpens*OPEN + p.NoOfRaises*0.6 + p.NoOfAllIns*ALLIN ) / ( p.NoOfFolds + p.NoOfChecks + p.NoOfCalls + p.NoOfOpens + p.NoOfRaises + p.NoOfAllIns );
        p.Aggresitivity = Aggr;
        if( Round > LEARN_RATE )
            /* Trust this value after 5 rounds */
            return Aggr;
        else
            /* Don't trust it as much after just a few rounds */
            return Aggr*( Round/LEARN_RATE );
    }

    public static double OpenCheckRatio( Player p, int Round )
    {
        /* Used to calculate if a player normally opens when he can or not.
         * If a player who normally doesn't open opens that probably means
         * that he has kinda good cards.
         *
         * Returns a value between 0.5 and 1.5 where closer to 1.5 means more opens
         * than checks.
         */
        
        double Aggr = ( ( p.NoOfOpens*1.0 ) / ( p.NoOfOpens + p.NoOfChecks )*1.0 );
        p.OpenRatio = Aggr + 0.5;
        if( Round >= LEARN_RATE )
            /* Trust this value after 4 rounds */
            return Aggr + 0.5;
        else
            /* Don't trust it as much after just a few rounds */
            return ( Aggr*( Round/LEARN_RATE ) + 0.5 );
    }
}
