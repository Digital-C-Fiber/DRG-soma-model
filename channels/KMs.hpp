

// xolotl
//
// component info: Fast sodium conductance
// component source [Tigerholm et al. 2014]

#pragma once
class conductance;

// inherit conductance class spec
class KMs: public conductance {

    public:

    // specify parameters + initial conditions
    KMs(double gbar_, double E_, double m_) {
        gbar = gbar_;
        E = E_;
        m = m_;


        // defaults
        if (isnan (E)) { E = -80; }

        p = 1;


        name = "KMs";

    }

    double m_inf(double, double);
    double tau_m(double, double);


};



double KMs::m_inf(double V, double Ca) {return 0.25/(1+exp(-(V+30)/6));}

double KMs::tau_m(double V, double Ca) {
    if (V < -60) {
        return
            219*1;}
    else { return (13*V+1000)*1;}

}
