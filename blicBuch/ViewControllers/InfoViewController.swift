//
//  InfoViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 3/28/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    
    @IBOutlet weak var titleHolderView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleHolderView.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.3)
        let line = NSAttributedString(string: "________________________________________\n\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 15)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let firstPart = NSAttributedString(string: "Verein Bücherliebhaber Club blitzBuch ZVR 1759468752 c/o Perica Anciger \nc/o Daniela Kukic \nPilgeringasse 21/1/1 \n1150 Wien \nBawag Bank: \nVerein „Bücherliebhaber Club blitzBuch“ \nXXXXXXXXXX \nXXXXXXXXXX \n\n\nDer Verein, dessen Tätigkeit nicht auf Gewinn gerichtet ist bezweckt die Zustellung von Büchern an Ihre Adresse in ganz Österreich. \nMan kann sich als Mitglied des Klubs für Bücherfreunde sehr leicht anmelden lassen- nämlich durch schnelles Registrieren. Das Mitglied startet die Applikation, macht den Klick auf das Buch, dass er an seine Hausadresse gesandt haben möchte und es wird von uns sofort geliefert. Falls Sie bereits Mitglied unseres Klubs sind, können Sie sich einfach durch die von Ihnen bereits bei der vorherigen Buchbestellung angegebene E-Mail Adresse einloggen. Die Mitgliedschaft im Klub ist im ersten Monat kostenlos und das Mitglied bekommt ein Buch wunschgemäß. Die vorher beantragten Angaben sind ausschließlich wegen einer präzisen Buchzustellung an Ihre Hausadresse erforderlich. Blitzbuch dient nur dazu, dass die Menschen ihre Liebe gegenüber den Büchern ausleben können und ohne große Hindernisse an das gewünschte Buch ankommen. Sollte der Club irgendwann nicht mehr in Betrieb sein, wird alles übergebliebene an einen Club mit der gleichen Absicht gespendet.\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partTwoTitle = NSAttributedString(string: "Mitgliedsbeitrag\n\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partTwo = NSAttributedString(string: "Der Mitgliedsbeitrag stellt eine Spende für unseren Leserklub dar. Nach dem ersten Probemonat können die Mitglieder 2,99€ einzahlen und danach sind sie berechtigt drei Bücher in diesem Monat zu bestellen (bzw. in den nächsten 30 Tagen ab der Einzahlung und der Bestätigung seitens des Administrators). Bei jeder Buchbestellung sind die Mitglieder aufgefordert die Versandkosten für das jeweilige Buch oder die Bücher zu übernehmen. Für unsere Mitglieder sind die Spendearten besonders interessant, die entweder Bücher oder Geld sein können. Durch die Spende können Sie der Erweiterung vom Titelangebot, der Appli- kationsinstandhaltung und der Entwicklung des Leserklubs verstärken. Erinnerung: Mitglieder des Clubs müssen die Bücher nicht zurückschicken. Sie können sie ruhig behalten oder Freunden / Familienmitgliedern weitergeben. Das Ziel ist, dass die Bücher es auf ihr Regal schaffen.\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partThreeTitle = NSAttributedString(string: "VIP Mitgliedsbeitrag des Bücherfreundeklubs\n\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partThree = NSAttributedString(string: "Durch die Spende  von 4,99€ oder mehr werden  die Mitglieder des Bücherfreundeklubs zu VIP Mitgliedern.  VIP Mitglieder können bis zu vier Bücher monatlich aus der VIP Bücherklasse bestellen (sie beinhaltet Popular belletristic).\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partFourTitle = NSAttributedString(string: "Pläne für die Zukunft\n\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partFour = NSAttributedString(string: "Erweiterung vom Büchertitelangebot,\nFörderung und  Erstellung einer immer bekwäheren Mobilapplikation,\nEinführung  kostenloser  Bücherzustellung auf dem ganzen Wien Gebiet,\nAußer Belletristic  auch Angebot von Enziklopädieherausgaben und Fachliteratur.\nSchließen Sie sich unserem Leserklub an und genießen Sie  Ihre beliebte Büchertitel !\n", attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        
        
        let newString = NSMutableAttributedString()
        newString.append(firstPart)
        newString.append(line)
        newString.append(partTwoTitle)
        newString.append(partTwo)
        newString.append(line)
        newString.append(partThreeTitle)
        newString.append(partThree)
        newString.append(line)
        newString.append(partFourTitle)
        newString.append(partFour)
        
        textView.attributedText = newString//NSAttributedString(string: "Verein Bücherliebhaber Club blitzBuch ZVR 1759468752 c/o Perica Anciger \nc/o Daniela Kukic \nPilgeringasse 21/1/1 \n1150 Wien \nBawag Bank: \nVerein „Bücherliebhaber Club blitzBuch“ \nXXXXXXXXXX \nXXXXXXXXXX \n——————————————————\nDer Verein, dessen Tätigkeit nicht auf Gewinn gerichtet ist bezweckt die Zustellung von Büchern an Ihre Adresse in ganz Österreich. \nMan kann sich als Mitglied des Klubs für Bücherfreunde sehr leicht anmelden lassen- nämlich durch schnelles Registrieren. Das Mitglied startet die Applikation, macht den Klick auf das Buch, dass er an seine Hausadresse gesandt haben möchte und es wird von uns sofort geliefert. Falls Sie bereits Mitglied unseres Klubs sind, können Sie sich einfach durch die von Ihnen bereits bei der vorherigen Buchbestellung angegebene E-Mail Adresse einloggen. Die Mitgliedschaft im Klub ist im ersten Monat kostenlos und das Mitglied bekommt ein Buch wunschgemäß. Die vorher beantragten Angaben sind ausschließlich wegen einer präzisen Buchzustellung an Ihre Hausadresse erforderlich. Blitzbuch dient nur dazu, dass die Menschen ihre Liebe gegenüber den Büchern ausleben können und ohne große Hindernisse an das gewünschte Buch ankommen. Sollte der Club irgendwann nicht mehr in Betrieb sein, wird alles übergebliebene an einen Club mit der gleichen Absicht gespendet.\n—————————————————\n\nMitgliedsbeitrag\n\nDer Mitgliedsbeitrag stellt eine Spende für unseren Leserklub dar. Nach dem ersten Probemonat können die Mitglieder 2,99€ einzahlen und danach sind sie berechtigt drei Bücher in diesem Monat zu bestellen (bzw. in den nächsten 30 Tagen ab der Einzahlung und der Bestätigung seitens des Administrators). Bei jeder Buchbestellung sind die Mitglieder aufgefordert die Versandkosten für das jeweilige Buch oder die Bücher zu übernehmen. Für unsere Mitglieder sind die Spendearten besonders interessant, die entweder Bücher oder Geld sein können. Durch die Spende können Sie der Erweiterung vom Titelangebot, der Appli- kationsinstandhaltung und der Entwicklung des Leserklubs verstärken. Erinnerung: Mitglieder des Clubs müssen die Bücher nicht zurückschicken. Sie können sie ruhig behalten oder Freunden / Familienmitgliedern weitergeben. Das Ziel ist, dass die Bücher es auf ihr Regal schaffen.\n——————————————————\n\nVIP Mitgliedsbeitrag des Bücherfreundeklubs\n\nDurch die Spende  von 4,99€ oder mehr werden  die Mitglieder des Bücherfreundeklubs zu VIP Mitgliedern.  VIP Mitglieder können bis zu vier Bücher monatlich aus der VIP Bücherklasse bestellen (sie beinhaltet Popular belletristic).\n——————————————————\n\nPläne für die Zukunft\n\nErweiterung vom Büchertitelangebot,\nFörderung und  Erstellung einer immer bekwäheren Mobilapplikation,\nEinführung  kostenloser  Bücherzustellung auf dem ganzen Wien Gebiet,\nAußer Belletristic  auch Angebot von Enziklopädieherausgaben und Fachliteratur.\nSchließen Sie sich unserem Leserklub an und genießen Sie  Ihre beliebte Büchertitel !\n")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
