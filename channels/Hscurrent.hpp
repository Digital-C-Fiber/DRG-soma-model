

// xolotl
//
// component info: Fast sodium conductance 
// component source [Tigerholm et al. 2014]

#pragma once
class conductance;

// inherit conductance class spec
class Hscurrent: public conductance {

public:

  // specify parameters + initial conditions
    Hscurrent(double gbar_, double E_, double m_) {
        gbar = gbar_;
        E = E_;
        m = m_;
       
        
        // defaults 
        if (isnan (E)) { E = -20; }

        p = 1;
        

        name = "Hscurrent";

        
        // define permeabilities to different ions
        perm.K = 0.5;
        perm.Na =0.5; 
    }
    

    double m_s(double, double);
    double tau_m(double, double);
    

};



double Hscurrent::m_s(double V, double Ca) {return 0.25/(1+exp((V+87.2)/9.7));}

double Hscurrent::tau_m(double V, double Ca) {
    if (V > -70) {
        return 
            300+542*exp((V+25)/(-20))*1;}
    else { return 2500+100*exp((V+240)/50)*1;}
}

