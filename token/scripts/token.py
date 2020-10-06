#!/usr/bin/python3

from brownie import Betting, accounts

accounts.load("metamask")

def main():
    return Betting.deploy({'from': accounts[0]})
