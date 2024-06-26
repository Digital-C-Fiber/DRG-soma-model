//x = xolotl

 //component info: Potassium conductance 
 //component source [Tigerholm et al. 2014]
#pragma once
class conductance;

//inherit conductance class spec
class KAa: public conductance {

public:

    //specify both gbar and E_rev and initial conditions
    KAa(double gbar_, double E_, double m_, double h_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;
        h = h_;

        // defaults 
        if (isnan (E)) { E = -80; }

        p = 1;
        q = 1;

        name = "KAa";
    }

    double m_inf(double, double);
    double tau_m(double, double);
    double h_inf(double, double);
    double tau_h(double, double);

};



double KAa::m_inf(double V, double Ca) {
    double m_inf_temp = (1.0/(1.0+exp(-(V+5.4-15)/16.4)));
     return m_inf_temp * m_inf_temp * m_inf_temp * m_inf_temp;} // ^4
double KAa::tau_m(double V, double Ca) {return 0.25+10.04*exp(-((V+24.67)*(V+24.67))/(2*(34.8*34.8)))*1;}
double KAa::h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+49.9-15)/4.6));}
double KAa::tau_h(double V, double Ca) {double tau_h_temp = 20+50*exp(-((V+40)*(V+40))/(2*(40*40)))*1;
    if (tau_h_temp < 5) {
       return 5;}
   else {
       return tau_h_temp;
   }
   }
