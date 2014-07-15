//
//  EvoMaterial.h
//  Evo Hex
//
//  Created by Steven Buell on 7/8/14.
//  Copyright (c) 2014 Steven Buell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvoMaterial : NSObject

@property NSString *name;
@property NSUInteger ID;

//Physical Properties
@property CGFloat density;
@property CGFloat heatDamagePoint;
@property CGFloat coldDamagePoint;


@property CGFloat bulkModulus; //Compressability of fluids  Bulk Modulus = Youngs * (1-2*Poisson)/3
@property CGFloat shearModulus; // YoungsModulus / 2*(1+Poisson)
@property CGFloat youngsModulus;
@property CGFloat poissonRatio;

//yieldStrength^2/(2*Modulus) = stamina per unit volume without distortion
@property CGFloat impactResilience;
@property CGFloat shearResilience;
@property CGFloat tensileResilience;

@property CGFloat compressiveStrength;
@property CGFloat shearStrength; //ultimate shear strength = Force/Cross-sectional area before FAILURE
@property CGFloat tensileStrength; // N/m^2 Force before FAILURE

//@property CGFloat frictionCoefficient;
//@property CGFloat restitutionCoefficient; Vb - Va / Ua - Ub (V = final, U = initial ; a = first object, b = second object)


//Optical properties
@property NSString *color;
@property CGFloat luminosity;
@property CGFloat absorbance; //percent light absorption
@property CGFloat albedo; //percent light reflected (diffuse)

//Thermal properties
@property CGFloat ignitionPoint;
@property CGFloat meltingPoint;
@property CGFloat boilingPoint;
@property CGFloat heatOfFusion;
@property CGFloat heatOfVaporization;
@property CGFloat specificHeat;
@property CGFloat thermalExpansionCoefficient;
@property CGFloat thermalConductivity; // W/(m*K) -> Thermal Insulance: thickness/conductivity =  K*m^2 / W

//Other
@property CGFloat resistivity;

- (EvoMaterial *) initFromDictionary:(NSDictionary *) data;

@end
