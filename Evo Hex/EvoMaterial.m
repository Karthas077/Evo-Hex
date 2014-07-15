//
//  EvoMaterial.m
//  Evo Hex
//
//  Created by Steven Buell on 7/8/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import "EvoMaterial.h"

@implementation EvoMaterial

- (EvoMaterial *) initFromDictionary:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        //Undefined values default to those of clay
        
        _density = [[data objectForKey:@"density"] doubleValue];
        if (!_density) {
            _density = 1900; //kg/m^3
        }
        
        _heatDamagePoint = [[data objectForKey:@"heatDamagePoint"] doubleValue];
        if (!_heatDamagePoint) {
            _heatDamagePoint = 0;
        }
        _coldDamagePoint = [[data objectForKey:@"coldDamagePoint"] doubleValue];
        if (!_coldDamagePoint) {
            _coldDamagePoint = 0;
        }
        
        //E = 2*G*(1+nu) = 3*K*(1-2*nu)
        _bulkModulus = [[data objectForKey:@"bulkModulus"] doubleValue];
        if (!_bulkModulus) {
            _bulkModulus = 3300; //kPa
        }
        _shearModulus = [[data objectForKey:@"shearModulus"] doubleValue];
        if (!_shearModulus) {
            _shearModulus = 1500; //kPa
        }
        _youngsModulus = [[data objectForKey:@"youngsModulus"] doubleValue];
        if (!_youngsModulus) {
            _youngsModulus = 4000; //kPa
        }
        _poissonRatio = [[data objectForKey:@"poissonRatio"] doubleValue];
        if (!_poissonRatio) {
            _poissonRatio = .3;
        }
        
        _compressiveStrength = [[data objectForKey:@"compressiveStrength"] doubleValue];
        if (!_compressiveStrength) {
            _compressiveStrength = 50;
        }
        _shearStrength = [[data objectForKey:@"shearStrength"] doubleValue]; //ultimate shear strength = Force/Cross-sectional area before FAILURE
        if (!_shearStrength) {
            _shearStrength = 50;
        }
        _tensileStrength = [[data objectForKey:@"tensileStrength"] doubleValue]; // N/m^2 Force before FAILURE
        if (!_tensileStrength) {
            _tensileStrength = 28.85;
        }
        
        //yieldStrength^2/(2*Modulus) = stamina per unit volume without distortion
        //J/m^3
        _impactResilience = 10 * pow(_compressiveStrength, 2) / _bulkModulus;
        _shearResilience = 10 * pow(_shearStrength, 2) / _shearModulus;
        _tensileResilience = 10 * pow(_tensileStrength, 2) / _youngsModulus;
        
        
        
        //Optical properties
        _color = [[data objectForKey:@"color"] stringValue];
        if (!_color) {
            _color = @"gray";
        }
        _luminosity = [[data objectForKey:@"luminosity"] doubleValue];
        if(!_luminosity) {
            _luminosity = 0;
        }
        _absorbance = [[data objectForKey:@"absorbance"] doubleValue]; //percent light absorption
        if (!_absorbance) {
            _absorbance = 1;
        }
        _albedo = [[data objectForKey:@"albedo"] doubleValue]; //percent light reflected (diffuse)
        if (!_albedo) {
            _albedo = 0.08;
        }
        
        //Thermal properties
        _ignitionPoint = [[data objectForKey:@"ignitionPoint"] doubleValue];
        if (!_ignitionPoint) {
            _ignitionPoint = -1;
        }
        _meltingPoint = [[data objectForKey:@"meltingPoint"] doubleValue];
        if (!_meltingPoint) {
            _meltingPoint = 2023.15;
        }
        _boilingPoint = [[data objectForKey:@"boilingPoint"] doubleValue];
        if (!_boilingPoint) {
            _boilingPoint = -1;
        }
        _heatOfFusion = [[data objectForKey:@"heatOfFusion"] doubleValue];
        if (!_heatOfFusion) {
            _heatOfFusion = 0;
        }
        _heatOfVaporization = [[data objectForKey:@"heatOfVaporization"] doubleValue];
        if (!_heatOfVaporization) {
            _heatOfVaporization = 0;
        }
        _specificHeat = [[data objectForKey:@"specificHeat"] doubleValue];
        if (!_specificHeat) {
            _specificHeat = 900; // J/kg*K
        }
        _thermalExpansionCoefficient = [[data objectForKey:@"thermalExpansionCoefficient"] doubleValue]; //10^−7/K
        if (!_thermalExpansionCoefficient) {
            _thermalExpansionCoefficient = 36;
        }
        _thermalConductivity = [[data objectForKey:@"thermalConductivity"] doubleValue]; // W/(m*K) -> Thermal Insulance: thickness/conductivity =  K*m^2 / W
        if (!_thermalConductivity) {
            _thermalConductivity = 1;
        }
        
        //Other
        _resistivity = [[data objectForKey:@"resistivity"] doubleValue];
        if (!_resistivity) {
            _resistivity = 32; // Ohm/m
        }
        
    }
    return self;
}

- (NSUInteger) hash
{
    return _ID;
}

@end
