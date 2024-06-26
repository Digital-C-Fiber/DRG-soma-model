// xolotl
//
// component info: Fast sodium conductance 
// component source [Tigerholm et al. 2014]
#pragma once
class conductance;

//inherit conductance class spec
class NaV19: public conductance {

public:

  // specify parameters + initial conditions
    NaV19(double gbar_, double E_, double m_, double h_) {
        gbar = gbar_;
        E = E_;
        m = m_;
        h = h_;
        
        // defaults 
        if (isnan (E)) { E = 30; }

        p = 1;
        q = 1;

        name = "NaV19";

    }

    double a_m(double, double);
    double b_m(double, double);
    double a_h(double, double);
    double b_h(double, double);
    double m_inf(double, double);
    double h_inf(double, double);
    double tau_m(double, double);
    double tau_h(double, double);
   

};


double NaV19::a_m(double V, double Ca) {return 1.032/(1.0+exp((V+6.99)/(-14.87115)));}
double NaV19::b_m(double V, double Ca) {return 5.79/(1.0+exp((V+130.4)/22.9));}
double NaV19::a_h(double V, double Ca) {return 0.06435/(1.0+exp((V+73.26415)/3.71928));}
double NaV19::b_h(double V, double Ca) {return 0.13496/(1.0+exp((V+10.27853)/(-9.09334)));}
double NaV19::m_inf(double V, double Ca) {return a_m(V, Ca) / (a_m(V, Ca) + b_m(V, Ca));}
double NaV19::h_inf(double V, double Ca) {return a_h(V, Ca) / (a_h(V, Ca) + b_h(V, Ca));}
double NaV19::tau_m(double V, double Ca) {return 1 / (a_m(V, Ca) + b_m(V, Ca)*1);}
double NaV19::tau_h(double V, double Ca) {return 1 / (a_h(V, Ca) + b_h(V, Ca)*1);}

