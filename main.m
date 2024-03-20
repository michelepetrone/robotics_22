% Questo script esegue gli altri nel giusto ordine
clear all; close all; clc; %reset matlab

% Calcolo della traiettoria del manipolatore
traiettoria_script;
% Calcolo del modello dinamico del manipolatore
DH_dinamica;
% Algoritmo di Inversione Cinematica
CLIK_script;
% Calcolo degli ellissoidi
ellissoidi;
% Esecuzione di un algoritmo di controllo
controllo_script;