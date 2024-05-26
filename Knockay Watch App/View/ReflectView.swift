import SwiftUI

struct ReflectView: View {
    var result: Result
    
    var body: some View {
        VStack(spacing:-15) {
            // Title
            Text("REFLECT").font(Font.custom("Witless", size: 25))
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
                .offset(x: 0, y: -15)
            
            
            ZStack{
                // Middle layer: Image SmallerDeck
                Image("SmallerDeck")
                    .resizable()
                    .frame(width: 140, height: 30)
                    .offset(x: 10, y: 5)
                    
                
                // Top layers: Text and Image for sticker
                HStack {
                    Image(result.stickerImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45) // Adjust size as needed
                        .offset(x: -15, y: 5)
                        
                    Text(result.stickerName).font(Font.custom("Witless", size: 22))
                        .font(.headline)
                        .offset(x: -10, y: 5)
                       
                    
                   
                }
            }.zIndex(4)
            
            ZStack {
                // Bottom-most layer: Container text with neon yellow color
                VStack {
                    Text(result.description)
                        .padding()
                        .foregroundColor(.black)
                        
                    .font(.system(size: 13))
                }
                .frame(width: 170, height: 120)
                .background(Color.neonYellow)
                .cornerRadius(25)
                .offset(x: 0, y: -5)
                    
               
                
            }
            .padding()
            
           
        }
    }
}

struct ReflectView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectView(result: resultsArray[0])
    }
}
