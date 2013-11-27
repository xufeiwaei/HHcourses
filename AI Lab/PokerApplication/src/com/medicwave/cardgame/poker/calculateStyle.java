/*
 * This class is used to evaluate playstyles of a player.
 */

package com.medicwave.cardgame.poker;

public class calculateStyle {

    public static double FOLD = 0.0;
    public static double CHECK = 0.3;
    public static double CALL = 0.5;
    public static double OPEN = 0.7;
    public static double RAISE = 0.8;
    public static double ALLIN = 1.0;
    public static double LEARN_RATE = 4.0;

    public static double CalcPlayStyle( Player player, int Round )
    {
        /* Calculate the aggresitivity of a player, give the value some rounds
         * to tune itself. A lot of all ins and raises gives an aggressive
         * player. Don't take an aggressive player's raises as serious as a
         * defensive player's raises.
         *
         * Returns a value between 0 and 1 where 0 is more defensive than 1.
         */
        double Aggr;
        Aggr = ( player.NoOfFolds*FOLD + player.NoOfChecks*CHECK + player.NoOfCalls*CALL
                + player.NoOfOpens*OPEN + player.NoOfRaises + player.NoOfAllIns*ALLIN ) / 
                ( player.NoOfFolds + player.NoOfChecks + player.NoOfCalls + player.NoOfOpens + player.NoOfRaises + player.NoOfAllIns );
        if( Round > LEARN_RATE )
        {    /* Trust this value after 5 rounds */
            player.Aggresitivity = Aggr;
            return Aggr;}
        else
        {/* Don't trust it as much after just a few rounds */
            player.Aggresitivity = Aggr*( Round/LEARN_RATE );
            return Aggr*( Round/LEARN_RATE );}
    }
}
