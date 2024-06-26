

// xolotl
//
// component info: Fast sodium conductance 
// component source [Tigerholm et al. 2014]

#pragma once
class conductance;

// inherit conductance class spec
class Hfcurrent: public conductance {

public:

  // specify parameters + initial conditions
    Hfcurrent(double gbar_, double E_, double m_) {
        gbar = gbar_;
        E = E_;
        m = m_;
       
        
        // defaults 
        if (isnan (E)) { E = -20; }

        p = 1;
       

        name = "Hfcurrent";
 
        
        // // define permeabilities to different ions
        perm.K = 0.5;
        perm.Na =0.5; 

    }

    double m_f(double, double);
    double tau_m(double, double);
    

};



double Hfcurrent::m_f(double V, double Ca) {return 0.25/(1+exp((V+87.2)/9.7));}

double Hfcurrent::tau_m(double V, double Ca) {
    if (V > -70.0) {return  140.0+50.0*exp((V+25.0)/(-20.0))*1.0;}
    else { return 250.0+12.0*exp((V+240.0)/50.0)*1.0;}
}

