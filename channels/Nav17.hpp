// xolotl
//
// component info: Fast sodium conductance 
// component source [Tigerholm et al. 2014]
#pragma once
class conductance;

//inherit conductance class spec
class Nav17: public conductance {

public:

  // specify parameters + initial conditions
    Nav17(double gbar_, double E_, double m_, double h_) {
        gbar = gbar_;
        E = E_;
        m = m_;
        h = h_;
        
        // defaults 
        if (isnan (E)) { E = 30; }

        p = 3;
        q = 1;

        name = "NaV17";

    }

    double m_inf(double, double);
    double h_inf(double, double);
    double tau_m(double, double);
    double tau_h(double, double);
    double a_m(double, double);
    double b_m(double, double);
    double a_h(double, double);
    double b_h(double, double);

};



double Nav17::m_inf(double V, double Ca) {return a_m(V, Ca) / (a_m(V, Ca) + b_m(V, Ca));}
double Nav17::h_inf(double V, double Ca) {return a_h(V, Ca) / (a_h(V, Ca) + b_h(V, Ca));}
double Nav17::tau_m(double V, double Ca) {return 1 / (a_m(V, Ca) + b_m(V, Ca)*1);}
double Nav17::tau_h(double V, double Ca) {return 1 / (a_h(V, Ca) + b_h(V, Ca)*1);}
double Nav17::a_m(double V, double Ca) {return 15.5/(1.0+exp((V-5.0)/(-12.08)));}
double Nav17::b_m(double V, double Ca) {return 35.2/(1.0+exp((V+72.7)/16.7));}
double Nav17::a_h(double V, double Ca) {return 0.38685/(1.0+exp((V+122.35)/15.29));}
double Nav17::b_h(double V, double Ca) {return -0.00283+2.00283/(1.0+exp((V+5.5266)/(-12.70195)));}