

// xolotl
//
// component info: Fast sodium conductance
// component source [Tigerholm et al. 2014]

#pragma once
class conductance;

// inherit conductance class spec
class KMf: public conductance {

    public:

    // specify parameters + initial conditions
    KMf(double gbar_, double E_, double m_) {
        gbar = gbar_;
        E = E_;
        m = m_;


        // defaults
        if (isnan (E)) { E = -80; }

        p = 1;


        name = "KMf";

    }

    double m_inf(double, double);
    double a (double, double);
    double b (double, double);
    double tau_m(double, double);




};



double KMf::m_inf(double V, double Ca) {return 0.75/(1.0+exp(-(V+30.0)/6.0));}
double KMf::a(double V, double Ca) { return 0.00395*exp((V+30.0)/40.0);}
double KMf::b(double V, double Ca) { return 0.00395*exp(-(V+30.0)/20.0)*1.0;}
double KMf::tau_m(double V, double Ca) { return 1.0/(a(V, Ca) +b(V, Ca));}


// a_m(V, Ca) / (a_m(V, Ca) + b_m(V, Ca))