//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Recep Bayraktar on 19.03.2021.
//

import Foundation

//MARK: Enums for Network Error Status
enum NetworkError: String, Error {
    case invalidRequest = "Unable to complete your request. Please check your internet connection"
    case invalidURL = "The URL is invalid. Please try again."
    case invalidResponse  = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server is invalid. Please try again."
}
