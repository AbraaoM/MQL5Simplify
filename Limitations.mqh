//+------------------------------------------------------------------+
//|                                                   InputCheck.mqh |
//|                                                   Abraão Moreira |
//|                                                abraaomoreira.com |
//+------------------------------------------------------------------+
#property copyright "Abraão Moreira"
#property link      "abraaomoreira.com"

#include <Trade/Trade.mqh>;
#include <MQL5Simplify/Utils.mqh>;
#include <MQL5Simplify/NewTypes.mqh>
#include <MQL5Simplify/Storage.mqh>

CUtils utilsOnLimit;

class CLimitations {
 private:
  CLocalStorage      *localState;

 public:
  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  CLimitations :: CLimitations () {

  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  CLimitations ::   ~CLimitations () { }

  //+------------------------------------------------------------------+
  //|  Time interval check function                                    |
  //+------------------------------------------------------------------+
  bool CLimitations :: InTimeInterval(string begin_, string finish_, bool control, bool showMessage) {
    if(!control)
      return true;
    if(begin_ <= TimeToString(TimeLocal(), TIME_MINUTES) &&
        TimeToString(TimeLocal(), TIME_MINUTES) < finish_)
      return true;

    if(showMessage)
      MessageBox("Out of operational time interval setted. \n\n" +
                 begin_ + " - " + finish_
                 + "\n\nPlease, change the configurations!");
    return false;
  }

  //+------------------------------------------------------------------+
  //|  Time limit check and close positions function                   |
  //+------------------------------------------------------------------+
  void CLimitations :: TimeLimit(string finish_, int deviation, bool control) {
    if((TimeToString(TimeLocal(), TIME_MINUTES) >= finish_) && control) {
      utilsOnLimit.CloseAllPositions(_Symbol, deviation);
    }
  }

  //+------------------------------------------------------------------+
  //|  Days of the week operations are enable function                 |
  //+------------------------------------------------------------------+
  bool CLimitations :: IsOperationDay(int &daysOn[]) {
    MqlDateTime strTimeLocal;
    TimeToStruct(TimeLocal(), strTimeLocal);
    for(int i = 0; i < ArraySize(daysOn); i++)
      if(strTimeLocal.day_of_week == daysOn[i])
        return true;
    return false;
  }

  //+------------------------------------------------------------------+
  //|  Profit limit reached function                                   |
  //+------------------------------------------------------------------+
  bool CLimitations :: ProfitReached(double profitMax_PR, datetime initDate_PR, datetime finishDate_PR) {
    double acum = utilsOnLimit.AcumulatedProfit(initDate_PR, finishDate_PR);
    if(utilsOnLimit.AcumulatedProfit(initDate_PR, finishDate_PR) >= profitMax_PR)
      return true;
    return false;
  }

  //+------------------------------------------------------------------+
  //|  Loss limit reached function                                     |
  //+------------------------------------------------------------------+
  bool CLimitations :: LossReached(double lossMax_LR, datetime initDate, datetime finishDate) {
    if(utilsOnLimit.AcumulatedProfit(initDate, finishDate) <= (lossMax_LR * -1))
      return true;
    return false;
  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  bool CLimitations :: PercentualGainReached(double percentage, datetime initDate, datetime finishDate) {
    double gainLimit;

    gainLimit = AccountInfoDouble(ACCOUNT_BALANCE) * percentage;
    return ProfitReached(gainLimit, initDate, finishDate);
  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  bool CLimitations :: PercentualLossReached(double percentage, datetime initDate, datetime finishDate) {
    double lossLimit;

    lossLimit = AccountInfoDouble(ACCOUNT_BALANCE) * percentage;
    return LossReached(lossLimit, initDate, finishDate);
  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  bool CLimitations :: NumberOfTradesReached (int expectedNumber, datetime initDate, datetime finishDate) {
    if(utilsOnLimit.NumberOfTrades(initDate, finishDate) >= expectedNumber)
      return true;
    return false;
  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  bool CLimitations :: OperationalTimeAccumReached (string limitTime, string storageName) {
    int openTime,
        localTime,
        timeOnOperationLimitTarget,
        sumTimeOnOperation;

    localState = new CLocalStorage(storageName);

    sumTimeOnOperation = StringToInteger(localState.GetState("timeOperationAcumm"));

    timeOnOperationLimitTarget = utilsOnLimit.StringTimeToInt(limitTime, HHMM);

    if(sumTimeOnOperation >= timeOnOperationLimitTarget) {
      delete localState;
      return true;
    }
    delete localState;
    return false;
  }
};
//+------------------------------------------------------------------+
