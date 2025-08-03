close all; clear; clc

addpath('Aircraft/', 'Modules/');

load('Aircraft/aero_data.mat');


results = runtests('TestsUnitaires');
disp(results);