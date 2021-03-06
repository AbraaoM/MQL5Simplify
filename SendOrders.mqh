//+------------------------------------------------------------------+
//|                                                 SimpleTrades.mqh |
//|                                                   Abraão Moreira |
//|                                                abraaomoreira.com |
//+------------------------------------------------------------------+
#property copyright "Abraão Moreira"
#property link      "abraaomoreira.com"

#include <Trade/Trade.mqh>
#include <MQL5Simplify/NewTypes.mqh>

class CSendOrders {
 public:
  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  void CSendOrders :: MarketOrderPoints(bool& m_requirements[],
                                        TRADE_TYPE m_tradeType,
                                        double m_volume,
                                        double m_takeProfit,
                                        double m_stopLoss) {
    for(int i = 0; i < ArrayRange(m_requirements, 0); i++)
      if(m_requirements[i] == false)
        return;

    CTrade trade_SO;
    double ask_SO,
           bid_SO;

    ask_SO = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
    bid_SO = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

    if(m_tradeType == SELL) {
      trade_SO.Sell(m_volume, NULL, bid_SO, bid_SO + m_stopLoss, bid_SO - m_takeProfit);
    }
    if(m_tradeType == BUY) {
      trade_SO.Buy(m_volume, NULL, ask_SO, ask_SO - m_stopLoss, ask_SO + m_takeProfit);
    }
  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  bool CSendOrders :: MarketOrderPrice(bool& m_requirements[],
                                       TRADE_TYPE m_tradeType,
                                       double m_volume,
                                       double m_takeProfit,
                                       double m_stopLoss) {
    for(int i = 0; i < ArrayRange(m_requirements, 0); i++)
      if(m_requirements[i] == false)
        return false;
    CTrade trade_SO;
    double ask_SO,
           bid_SO;

    ask_SO = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
    bid_SO = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

    if(m_tradeType == SELL) {
      trade_SO.Sell(m_volume, NULL, bid_SO, m_stopLoss, m_takeProfit);
      return true;
    }
    if(m_tradeType == BUY) {
      trade_SO.Buy(m_volume, NULL, ask_SO, m_stopLoss, m_takeProfit);
      return true;
    }
    return false;
  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  bool CSendOrders :: StopOrderPrice(bool& m_requirements[],
                                     TRADE_TYPE m_tradeType,
                                     double m_volume,
                                     double m_price,
                                     double m_takeProfit,
                                     double m_stopLoss) {
    for(int i = 0; i < ArrayRange(m_requirements, 0); i++)
      if(m_requirements[i] == false)
        return false;

    CTrade trade_SO;

    if(m_tradeType == SELL) {
      return trade_SO.SellStop(m_volume, m_price, NULL, m_stopLoss, m_takeProfit);
    }
    if(m_tradeType == BUY) {
      return trade_SO.BuyStop(m_volume, m_price, NULL, m_stopLoss, m_takeProfit);
    }
    return false;
  }

  //+------------------------------------------------------------------+
  //|                                                                  |
  //+------------------------------------------------------------------+
  bool CSendOrders :: LimitOrderPrice(bool& m_requirements[],
                                      TRADE_TYPE m_tradeType,
                                      double m_volume,
                                      double m_price,
                                      double m_takeProfit,
                                      double m_stopLoss) {
    for(int i = 0; i < ArrayRange(m_requirements, 0); i++)
      if(m_requirements[i] == false)
        return false;

    CTrade trade_SO;

    if(m_tradeType == SELL) {
      trade_SO.SellLimit(m_volume, m_price, NULL, m_stopLoss, m_takeProfit);
      return true;
    }
    if(m_tradeType == BUY) {
      trade_SO.BuyLimit(m_volume, m_price, NULL, m_stopLoss, m_takeProfit);
      return true;
    }
    return false;
  }
};
//+------------------------------------------------------------------+
