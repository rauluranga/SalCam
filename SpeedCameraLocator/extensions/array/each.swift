extension Array{
    func each(each: (T) -> ()){
        for object: T in self {
            each(object)
        }
    }
}

