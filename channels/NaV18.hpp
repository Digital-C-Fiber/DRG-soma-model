

// xolotl
//
// component info: Fast sodium conductance 
// component source [Tigerholm et al. 2014]

#pragma once
class conductance;

// inherit conductance class spec
class NaV18: public conductance {

public:

  // specify parameters + initial conditions
    NaV18(double gbar_, double E_, double m_, double h_) {
        gbar = gbar_;
        E = E_;
        m = m_;
        h = h_;
        
        // defaults 
        if (isnan (E)) { E = 30; }

        p = 3;
        q = 1;

        name = "NaV18";

    }

    double m_inf(double, double);
    double h_inf(double, double);
    double tau_m(double, double);
    double tau_h(double, double);
    double a_m(double, double);
    double b_m(double, double);
    

};



double NaV18::m_inf(double V, double Ca) {return a_m(V, Ca) / (a_m(V, Ca) + b_m(V, Ca));}
double NaV18::h_inf(double V, double Ca) {return 1.0/(1.0+exp((V+32.2)/4));}
double NaV18::tau_m(double V, double Ca) {return 1 / (a_m(V, Ca) + b_m(V, Ca)*1);}
double NaV18::tau_h(double V, double Ca) {return 1.218+42.043*exp(-((V+38.1)*(V+38.1))/(2.0*15.19*15.19))*1.0;}
double NaV18::a_m(double V, double Ca) {return 2.85-2.839/(1.0+exp((V-1.159)/13.95));}
double NaV18::b_m(double V, double Ca) {return 7.6205/(1.0+exp((V+46.463)/8.8289));}


