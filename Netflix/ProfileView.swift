import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var favoriteMovies: String = ""
    @State private var postContent: String = ""
    @State private var posts: [String] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 10) {
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    
                    TextField("Favourite Movies", text: $favoriteMovies)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("New Post")
                        .font(.headline)
                    
                    TextEditor(text: $postContent)
                        .frame(height: 100)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    Button(action: addPost) {
                        Text("Add Post")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Posts")
                        .font(.headline)
                    
                    ForEach(posts, id: \.self) { post in
                        Text(post)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
                
                Button(action: saveChanges) {
                    Text("Save Changes")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color("NetflixBackground").ignoresSafeArea())
            .onAppear(perform: loadProfileData)
        }
    }
        
    private func addPost() {
        if !postContent.isEmpty {
            posts.append(postContent)
            postContent = ""
        }
    }
    
    private func saveChanges() {
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(lastName, forKey: "lastName")
        UserDefaults.standard.set(favoriteMovies, forKey: "favoriteMovies")
        UserDefaults.standard.set(posts, forKey: "posts")
        
        dismiss()
    }
    
    private func loadProfileData() {
        firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
        lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""
        favoriteMovies = UserDefaults.standard.string(forKey: "favoriteMovies") ?? ""
        posts = UserDefaults.standard.stringArray(forKey: "posts") ?? []
    }
}
