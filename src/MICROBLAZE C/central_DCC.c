#include "xgpio.h"
#include "centrale_DCC.h"
#include "xparameters.h"
#include "xil_io.h"

int main(int argc,char *argv[]){

	//******* INIT LED GPIO ******//
	XGpio led;
	XGpio_Initialize(&led,XPAR_LED_DEVICE_ID);
	XGpio_SetDataDirection(&led,1,0);


	//******* INIT SW BOUTON GPIO ******//
	XGpio button_sw;
	XGpio_Initialize(&button_sw,XPAR_BOUTON_SWITCH_DEVICE_ID);
	XGpio_SetDataDirection(&button_sw,1,1);
	XGpio_SetDataDirection(&button_sw,2,1);

	
	//Definition des preambules 
	u32 preambu_long = 0b11111111111111111111111;
	u32 preambu_short = 0b11111111111111;

	//Definition de l adresse et de la vitesse du train
	u32 vit = 0b00000;
	u32 addr = 0b00000011;

	//Variable pour stocker les octets de nos fonctions
	u32 fonction;
	u32 fonction1;

	//Variable pour le calcul du xor
	u32 xor;

	//Variable pour envoyer les trames a travers des slaves registers
	u32 send_trame = 0b11111111111111111111111000000000;
	u32 send_trame1 = 0b0000000000000000001;

	while(1){

		//Lecture des switchs et des boutons
		int val;
		int btn;
		val = XGpio_DiscreteRead(&button_sw,2);
		btn = XGpio_DiscreteRead(&button_sw,1);


		//Affichage de la vitesse et de l'adresse
		XGpio_DiscreteWrite(&led,1,(addr) + (vit << 10));

		//Variable de trames temporaire
		u32 trame;
		u32 trame1;


		//FONCTION F0 : LUM ON 
		if ((val & 0xFF) == 1) {
			//Octet 1 de la fonction
			fonction = 0b10010000;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F1 : SON ON 
		if ((val & 0xFF) == 2){
			//Octet 1 de la fonction
			fonction = 0b10000001;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F2 : COR 1 
		if ((val & 0xFF) == 3){
			//Octet 1 de la fonction
			fonction = 0b10000010;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F3 : COR 2
		if ((val & 0xFF) == 4){
			//Octet 1 de la fonction
			fonction = 0b10000100;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F4 : TURBO OFF
		if ((val & 0xFF) == 5){
			//Octet 1 de la fonction
			fonction = 0b10001000;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION : F0 a F4 OFF
		if ((((val & 0xFF) == 1) || ((val & 0xFF) == 2) || ((val & 0xFF) == 3) || ((val & 0xFF) == 4) || ((val & 0xFF) == 5)) && (val & 0b100000000000000)){
			//Octet 1 de la fonction
			fonction = 0b10000000;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F5 : COMPRESSEUR
		if ((val & 0xFF) == 6){
			//Octet 1 de la fonction
			fonction = 0b10110001;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F6 : ACCELERATION
		if ((val & 0xFF) == 7){
			//Octet 1 de la fonction
			fonction = 0b10110010;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F7 : Courbe Grincement
		if ((val & 0xFF) == 8){
		  //Octet 1 de la fonction
			fonction = 0b10110100;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F8 : Ferroviaire Clank
		if ((val & 0xFF) == 9){
		  //Octet 1 de la fonction
			fonction = 0b10111000;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F5-F8 OFF
		if ((((val & 0xFF) == 9) || ((val & 0xFF) == 8) || ((val & 0xFF) == 7) || ((val & 0xFF) == 6)) && (val & 0b100000000000000)){
			//Octet 1 de la fonction
			fonction = 0b10110000;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F9 : Ventillateur
		if ((val & 0xFF) == 10){
			//Octet 1 de la fonction
			fonction = 0b10100001;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F10 : Conducteur de signal
		if ((val & 0xFF) == 11){
			//Octet 1 de la fonction
			fonction = 0b10100010;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F11 : Court Cor 1
		if ((val & 0xFF) == 12){
			//Octet 1 de la fonction
			fonction = 0b10100100;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F12 : Court Cor 2
		if ((val & 0xFF) == 13){
			//Octet 1 de la fonction
			fonction = 0b10101000;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F9-12 OFF
		if ((((val & 0xFF) == 13) || ((val & 0xFF) == 12) || ((val & 0xFF) == 11) || ((val & 0xFF) == 10)) && (val & 0b100000000000000)){
			//Octet 1 de la fonction
			fonction = 0b10100000;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F13 : Annonce station 1
		if ((val & 0xFF) == 14){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b00000001;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F14 : Annonce station 2
		if ((val & 0xFF) == 15){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b00000010;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F15 : Signal alert 1
		if ((val & 0xFF) == 16){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b00000100;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F16 : Signal alert 2
		if ((val & 0xFF) == 17){
			//Octet 1 de la fonction
			fonction  = 0b11011110;
			
			//Octet 2 de la fonction
			fonction1 = 0b00001000;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F17 : Port chauffeur 
		if ((val & 0xFF) == 18){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b00010000;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F18 : Valve
		if ((val & 0xFF) == 19){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b00100000;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F19 : Attelage 
		if ((val & 0xFF) == 20){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b01000000;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION F20 : Sable
		if ((val & 0xFF) == 21){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b10000000;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}


		//FONCTION F13-F21 OFF
		if ((((val & 0xFF) == 21) || ((val & 0xFF) == 20) || ((val & 0xFF) == 19) || ((val & 0xFF) == 18) || ((val & 0xFF) == 17) || ((val & 0xFF) == 16) || ((val & 0xFF) == 15) || ((val & 0xFF) == 14)) && (val & 0b100000000000000)){
			//Octet 1 de la fonction
			fonction  = 0b11011110;

			//Octet 2 de la fonction
			fonction1 = 0b00000000;

			//Calcul checksum
			xor = (addr ^ fonction) ^ fonction1;

			//Affectation valeur trames
			trame = (preambu_short << 17) + (0b0 << 16) + (addr << 9) + (0b0 << 8) + fonction;
			trame1 = (0b0 << 11) + (fonction1 << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//FONCTION RESET
		if ((val & 0xFF) == 22){
			//Affectation valeur trames
			trame =  0b11111111111111111111111000000000;
		  trame1 = 0b0000000000000000001;
		}

		//AUGMENTATION VITESSE SI APPUIE BTN DROIT
		if (btn & 8){
			//Augmentation valeur de vitesse
			vit = (vit + 0b1) % 0b100000;

			//Octet 1 de la fonction
			fonction = (0b011 << 5) + vit;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//REDUCTION VITESSE SI APPUIE BTN GAUCHE
		if (btn & 4){
			//Reduction valeur de vitesse
			vit = (vit - 0b1) % 0b100000;

			//Octet 1 de la fonction
			fonction = (0b011 << 5) + vit;

			//Calcul checksum
			xor = addr ^ fonction;

			//Affectation valeur trames
			trame = (preambu_long << 9) + (0b0 << 8) + addr;
			trame1 = (0b0 << 11) + (fonction << 10) + (0b0 << 9) + (xor << 1) + 0b1;
		}

		//AUGMENTATION ADRESSE SI BTN HAUT
		if (btn & 2){
			//Augmentation adresse
 			addr = (addr + 0b1) % 0b100000000;
		}

		//REDUCTION VITESSE SI BTN BAS
		if (btn & 16){
			//Reduction adresse
			addr = (addr - 0b1) % 0b100000000;
		}

		//CHANGMENT DE TRAME SI BTN MILIEU
		if (btn & 1){	
			//Affectation de la nouvelle trame
			send_trame = trame;
			send_trame1 = trame1;
		}

		int cpt = 0;
		while(cpt < 500000){cpt++;}

		//Envoie sur slave register
		CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG0_OFFSET,send_trame );
		CENTRALE_DCC_mWriteReg(XPAR_CENTRALE_DCC_0_S00_AXI_BASEADDR, CENTRALE_DCC_S00_AXI_SLV_REG1_OFFSET,send_trame1);
	}
}
