//
//  FiveGuysManager.swift
//  Kiosk
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import Foundation

final class OrderManager {
    
    func pay(userInfo: UserInfo) {
        // 결재 or 장바구니 제거 or 돌아가기
        
        while true {
            let amount = UserInfo.poket.reduce(0) { $0 + $1.price }
            
            print("1. 결재 \n2. 장바구니 \n3. 메인메뉴")
            
            let text = readLine()
            
            switch text {
            case "1":
                guard UserInfo.poket.isEmpty != true else {
                    print("장바구니가 비었습니다.")
                    return
                }
                if userInfo.money > amount {
                    userInfo.money -= amount
                    print("결재가 완료됐습니다.")
                    print("잔액 \(floor(userInfo.money * 1000))")
                    userInfo.emptyPoket()
                    return
                } else { print("\(floor(amount - userInfo.money) * 1000)원이 부족합니다, 장바구니를 비워주세요.")
                    continue
                }
            case "2":
                guard UserInfo.poket.isEmpty != true else {
                    print("장바구니가 비었습니다.")
                    return
                }
                
            while true {
                print("장바구니 항목")
                for food in UserInfo.poket {
                    print("\(food.name) | W \(food.price) |")
                }
                print("\n1. 장바구니에서 제거하기 \n2. 결재하기")
                let text = readLine()
                switch text {
                case "1":
                INTER: while true {
                        printPickedMenu(pickMenus: UserInfo.poket)
                        guard let text = readLine(),
                              let text = Int(text) else { continue }
                        switch text {
                        case 1...UserInfo.poket.count:
                            userInfo.removePoket(index: text - 1)
                            continue
                        case 0:
                            break INTER
                        default: print("올바른 메뉴를 입력해주세요. \n")
                        }
                    }
                case "2":
                    guard UserInfo.poket.isEmpty != true else {
                        print("장바구니가 비었습니다.")
                        return
                    }
                    if userInfo.money > amount {
                        userInfo.money -= amount
                        print("결재가 완료됐습니다.")
                        print("잔액 \(floor(userInfo.money * 1000))")
                        userInfo.emptyPoket()
                        return
                    }
                default:
                    continue
                }
            }
            case "3":
                return
                // 삭제 and 결재
            default: print("올바른 메뉴를 입력해주세요. \n")
                continue
            }
        }
        
    }
    
    func orderDrinks(type: Product, userInfo: UserInfo) {
        var drinkList: [Menu] = []
        
        for i in type.productName.indices {
            drinkList.append(Menu(type.productName[i], type.productPrice[i]))
        }
        
        
        
        while true {
            printDrinksMenu(type: type, drinkList, pickMenus: UserInfo.poket)
            guard let userInput = readLine(),
                  let userInput = Int(userInput) else {
                print("올바른 메뉴를 입력해주세요. 가드 \n")
                continue
            }
            //
            if UserInfo.poket.isEmpty && userInput == drinkList.count + 1 {
                print("올바른 메뉴를 입력해주세요. \n")
                continue
            }
            
            switch userInput {
            case 0:
                print("뒤로가기를 선택하셨습니다. \n")
                return
            case (1...drinkList.count):
                userInfo.updatePoket(food: drinkList[userInput - 1])
                //print("\(drinkList[userInput - 1].name)를 주문하셨습니다. 가격은 \(drinkList[userInput - 1].price)000원 입니다. \n")
                print("\(drinkList[userInput - 1].name)가 장바구니에 담겼습니다. \n")
                continue
                
            case drinkList.count + 1: // 삭제
                
            INTER:while true {
                printPickedMenu(pickMenus: UserInfo.poket)
                
                guard UserInfo.poket.isEmpty != true else {
                    print("장바구니가 비었습니다.")
                    break
                }
                
                guard let userInput = readLine(),
                      let userInput = Int(userInput) else { continue }
                
                switch userInput {
                case 1...UserInfo.poket.count:
                    userInfo.removePoket(index: userInput - 1)
                case 0:
                    break INTER
                default: print("올바른 메뉴를 입력해주세요. \n")
                }
            }
                
            default:
                print("올바른 메뉴를 입력해주세요. \n")
            }
        }
    }
}

extension OrderManager {
    func printDrinksMenu(type: Product, _ drinkList: [Menu], pickMenus: [Menu]) {
        print("[ \(type.name) MENU ]")
        for (index, drink) in drinkList.enumerated() {
            print("\(index + 1). \(drink.name) | W \(drink.price) |")
        }
        if !pickMenus.isEmpty {
            // print("====================================")
            print("\(drinkList.count + 1). 메뉴 취소")
        }
        print("0. 뒤로가기\n")
    }
    
    func printPickedMenu(pickMenus: [Menu]) {
        print("취소할 식품을 선택해주세요.")
        for (index, drink) in pickMenus.enumerated() {
            print("\(index + 1). \(drink.name) | W \(drink.price) |")
        }
        print("0. 뒤로가기\n")
    }
}
