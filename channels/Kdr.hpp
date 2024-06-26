// xolotl
//
// component info: Potassium conductance 
// component source [Tigerholm et al. 2014]
#pragma once
class conductance;

//inherit conductance class spec
class Kdr: public conductance {

public:

    //specify both gbar and E_rev and initial conditions
    Kdr(double gbar_, double E_, double m_)
    {
        gbar = gbar_;
        E = E_;
        m = m_;

        // defaults 
        if (isnan (E)) { E = -80; }

        p = 4;

        name = "Kdr";
    }

    double m_inf(double, double);
    double tau_m(double, double);

};



double Kdr::m_inf(double V, double Ca) {return 1.0/(1.0+exp(-(V+25)/15.4));}
double Kdr::tau_m(double V, double Ca) {
    if (V > -31){
        return 1000*(0.000688+1/(exp((V+75.2)/6.5)+exp((V-131.5)/(-34.8))))*1;
    }
    else {
        return 0.16 + 0.8*exp(-0.0267*(V+11))*1;
    }
}